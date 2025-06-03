import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../../orders/providers/cart_provider.dart';
import '../../../orders/providers/order_provider.dart';
import '../../../tables/providers/table_provider.dart';
import '../widgets/category_sidebar.dart';
import '../widgets/product_card.dart';
import '../../widgets/order_summary_card.dart';
import '../../widgets/order_item_list_tile.dart';
import '../../../orders/presentation/widgets/cart_drawer.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/order_status.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final String tableId;
  final String? orderId;

  const ProductsPage({
    Key? key, 
    required this.tableId,
    this.orderId,
  }) : super(key: key);

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  String? _selectedCategoryId;
  String _searchQuery = '';
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _uuid = const Uuid();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    // Load products and categories
    Future.microtask(() {
      ref.read(productProvider.notifier).loadProducts();
      ref.read(categoryProvider.notifier).loadCategories();
      
      // If we have an existing order, load it into the cart
      if (widget.orderId != null && widget.orderId!.isNotEmpty) {
        _loadExistingOrder();
      } else {
        // Clear the cart for a new order
        ref.read(cartProvider.notifier).clearCart();
      }
    });
  }

  Future<void> _loadExistingOrder() async {
    setState(() => _isLoading = true);
    try {
      final orderNotifier = ref.read(orderProvider.notifier);
      final order = await orderNotifier.getOrderById(widget.orderId!);
      
      if (order != null) {
        // Load the order items into the cart
        ref.read(cartProvider.notifier).loadCartFromOrder(order);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sipariş yüklenirken hata oluştu: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _searchQuery = '';
      _searchController.clear();
    });

    if (categoryId == null) {
      ref.read(productProvider.notifier).loadProducts();
    } else {
      ref.read(productProvider.notifier).loadProductsByCategory(categoryId);
    }
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
        _selectedCategoryId = null;
      });
      
      if (query.isNotEmpty) {
        ref.read(productProvider.notifier).searchProducts(query);
      } else {
        ref.read(productProvider.notifier).loadProducts();
      }
    });
  }

  Future<void> _saveOrder() async {
    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sipariş boş, lütfen ürün ekleyin')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final orderNotifier = ref.read(orderProvider.notifier);
      final cartNotifier = ref.read(cartProvider.notifier);
      final total = cartNotifier.getTotal();
      
      if (widget.orderId != null) {
        // Update existing order
        final existingOrder = await orderNotifier.getOrderById(widget.orderId!);
        if (existingOrder != null) {
          final updatedOrder = existingOrder.copyWith(
            items: cartItems,
            totalAmount: total,
            updatedAt: DateTime.now(),
          );
          
          final success = await orderNotifier.updateOrder(updatedOrder);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sipariş başarıyla güncellendi')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sipariş güncellenirken hata oluştu')),
            );
          }
        }
      } else {
        // Generate sequential order number
        final orderNumber = await orderNotifier.generateOrderNumber();
        
        // Create new order
        final newOrder = Order(
          id: _uuid.v4(),
          orderNumber: orderNumber,
          tableNumber: widget.tableId,
          tableId: widget.tableId,
          items: cartItems,
          status: OrderStatus.pending,
          totalAmount: total,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          userId: null,
          discountAmount: null,
          paymentMethod: null,
          metadata: null,
        );
        
        final orderId = await orderNotifier.createOrder(newOrder);
        if (orderId != null) {
          // Update the URL to include the new order ID
          if (mounted) {
            context.go('/tables/${widget.tableId}/order?orderId=$orderId');
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sipariş başarıyla oluşturuldu')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sipariş oluşturulurken hata oluştu')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sipariş kaydedilirken hata oluştu: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _goToPayment() async {
    if (widget.orderId == null || widget.orderId!.isEmpty) {
      // We need to save the order first
      await _saveOrder();
      
      // If we still don't have an orderId, the save failed
      if (widget.orderId == null || widget.orderId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ödeme ekranına geçmeden önce siparişi kaydedin')),
        );
        return;
      }
    }
    
    // Navigate to payment page with both orderId and tableId
    if (mounted) {
      context.go('/payments?orderId=${widget.orderId}&tableId=${widget.tableId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the table data to get the real table name
    final tableAsync = ref.watch(tableByIdProvider(widget.tableId));
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: tableAsync.when(
          data: (table) => Text(table?.name ?? 'Masa ${widget.tableId}'),
          loading: () => Text('Masa ${widget.tableId}'),
          error: (_, __) => Text('Masa ${widget.tableId}'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(productProvider);
              ref.refresh(categoryProvider);
              if (widget.orderId != null) {
                _loadExistingOrder();
              }
            },
          ),
        ],
      ),
      endDrawer: CartDrawer(
        tableId: widget.tableId,
        orderId: widget.orderId,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ResponsiveLayout.builder(
              context: context,
              mobile: _buildMobileLayout(),
              tablet: _buildTabletLayout(),
              desktop: _buildTabletLayout(),
            ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Order summary section (top)
        Expanded(
          flex: 4,
          child: Column(
            children: [
              OrderSummaryCard(
                tableId: widget.tableId,
                orderId: widget.orderId,
              ),
              Expanded(
                child: _buildOrderItemsList(),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
        const Divider(height: 1),
        // Product catalog section (bottom)
        Expanded(
          flex: 6,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Ürün ara...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: _onSearch,
                ),
              ),
              // Categories row
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CategorySidebar(
                    orientation: Axis.horizontal,
                    selectedCategoryId: _selectedCategoryId,
                    onCategorySelected: _onCategorySelected,
                  ),
                ),
              ),
              // Products grid
              Expanded(
                child: _buildProductsGrid(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order summary section (left)
        SizedBox(
          width: 400,
          child: Column(
            children: [
              OrderSummaryCard(
                tableId: widget.tableId,
                orderId: widget.orderId,
              ),
              Expanded(
                child: _buildOrderItemsList(),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
        // Vertical divider
        const VerticalDivider(width: 1),
        // Product catalog section (right)
        Expanded(
          child: Column(
            children: [
              // Search and category section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Ürün ara...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearch('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: _onSearch,
                      ),
                    ),
                  ],
                ),
              ),
              // Categories and products area
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories sidebar
                    SizedBox(
                      width: 220,
                      child: CategorySidebar(
                        orientation: Axis.vertical,
                        selectedCategoryId: _selectedCategoryId,
                        onCategorySelected: _onCategorySelected,
                      ),
                    ),
                    // Products grid
                    Expanded(
                      child: _buildProductsGrid(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemsList() {
    final cartItems = ref.watch(cartProvider);
    
    if (cartItems.isEmpty) {
      return const Center(
        child: Text(
          'Sepetinizde ürün bulunmuyor',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return OrderItemListTile(item: cartItems[index]);
      },
    );
  }

  Widget _buildProductsGrid() {
    final products = ref.watch(productProvider);
    
    return products.when(
      data: (productsList) {
        if (productsList.isEmpty) {
          return const Center(
            child: Text(
              'Ürün bulunamadı',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveLayout.isDesktop(context)
                ? 4
                : ResponsiveLayout.isTablet(context)
                    ? 3
                    : 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: productsList.length,
          itemBuilder: (context, index) {
            final product = productsList[index];
            return ProductCard(
              product: product,
              onTap: () => _addToCart(product),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Ürünler yüklenirken hata oluştu: $error'),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _saveOrder,
              icon: const Icon(Icons.save),
              label: const Text('SİPARİŞİ KAYDET'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _goToPayment,
              icon: const Icon(Icons.payment),
              label: const Text('ÖDEMEYE GEÇ'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(Product product) {
    ref.read(cartProvider.notifier).addItem(product, 1);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} sepete eklendi'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'GERI AL',
          onPressed: () {
            ref.read(cartProvider.notifier).removeItem(product.id);
          },
        ),
      ),
    );
  }
} 