import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../products/providers/category_provider.dart';
import '../../products/providers/product_provider.dart';
import '../providers/table_order_provider.dart';
import '../widgets/draft_orders_section.dart';
import '../widgets/existing_orders_section.dart';
import '../../tables/providers/table_provider.dart';
import '../../orders/providers/order_provider.dart';
import 'dart:async';

import '../../../core/utils/responsive_layout.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/models.dart';
import '../../products/presentation/widgets/category_sidebar.dart';
import '../../products/presentation/widgets/product_card.dart';
import 'package:ravpos/shared/models/table_status.dart';
import 'package:uuid/uuid.dart';
import '../../users/providers/user_provider.dart';
import 'package:ravpos/shared/models/order.dart';
import 'package:ravpos/shared/models/order_status.dart';
import 'package:ravpos/shared/models/order_item.dart';

class TableOrderPage extends ConsumerStatefulWidget {
  final String tableId;
  final String? orderId;

  const TableOrderPage({
    Key? key,
    required this.tableId,
    this.orderId,
  }) : super(key: key);

  @override
  ConsumerState<TableOrderPage> createState() => _TableOrderPageState();
}

class _TableOrderPageState extends ConsumerState<TableOrderPage> {
  String? _selectedCategoryId;
  String _searchQuery = '';
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Load data when page initializes
    Future.microtask(() {
      ref.read(productProvider.notifier).loadProducts();
      ref.read(categoryProvider.notifier).loadCategories();
      
      // Initialize table order data
      ref.read(tableOrderProvider(widget.tableId).notifier).loadExistingOrders();
    });
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

  @override
  Widget build(BuildContext context) {
    // Watch the table data to get the real table name
    final tableAsync = ref.watch(tableByIdProvider(widget.tableId));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: tableAsync.when(
          data: (table) => Text('Adisyon - ${table?.name ?? 'Masa ${widget.tableId}'}'),
          loading: () => Text('Adisyon - Masa ${widget.tableId}'),
          error: (_, __) => Text('Adisyon - Masa ${widget.tableId}'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(productProvider);
              ref.refresh(categoryProvider);
              ref.read(tableOrderProvider(widget.tableId).notifier).loadExistingOrders();
            },
          ),
        ],
      ),
      body: ResponsiveLayout.builder(
        context: context,
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final tableOrderState = ref.watch(tableOrderProvider(widget.tableId));
    final draftCount = tableOrderState.draftOrders.length;
    final existingCount = tableOrderState.existingOrders.length;
    // Flex factors: at least 1
    final draftFlex = draftCount > 0 ? draftCount : 1;
    final existingFlex = existingCount > 0 ? existingCount : 1;
    return Column(
      children: [
        // Orders window grouping new & existing orders
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Draft orders section
                  Flexible(
                    flex: draftFlex,
                    child: DraftOrdersSection(tableId: widget.tableId, orderId: widget.orderId),
                  ),
                  const SizedBox(height: 4),
                  // Existing orders section
                  Flexible(
                    flex: existingFlex,
                    child: ExistingOrdersSection(tableId: widget.tableId, orderId: widget.orderId),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const Divider(height: 1, thickness: 2),
        
        // Product catalog section (bottom half)
        Expanded(
          flex: 1,
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
    final tableOrderState = ref.watch(tableOrderProvider(widget.tableId));
    final draftCount = tableOrderState.draftOrders.length;
    final existingCount = tableOrderState.existingOrders.length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Orders window grouping new & existing orders
        SizedBox(
          width: 450,
          child: Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Flexible(
                    flex: draftCount,
                    child: DraftOrdersSection(tableId: widget.tableId, orderId: widget.orderId),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    flex: existingCount,
                    child: ExistingOrdersSection(tableId: widget.tableId, orderId: widget.orderId),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Vertical divider
        const VerticalDivider(width: 1, thickness: 2),
        
        // Product catalog section (right side)
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

  Widget _buildDesktopLayout() {
    final tableOrderState = ref.watch(tableOrderProvider(widget.tableId));
    final draftCount = tableOrderState.draftOrders.length;
    final existingCount = tableOrderState.existingOrders.length;
    final draftFlex = draftCount > 0 ? draftCount : 1;
    final existingFlex = existingCount > 0 ? existingCount : 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Orders window grouping new & existing orders
        SizedBox(
          width: 500,
          child: Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Flexible(
                    flex: draftFlex,
                    child: DraftOrdersSection(tableId: widget.tableId, orderId: widget.orderId),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    flex: existingFlex,
                    child: ExistingOrdersSection(tableId: widget.tableId, orderId: widget.orderId),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Vertical divider
        const VerticalDivider(width: 1, thickness: 2),
        
        // Product catalog section (right side)
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
                      flex: 2,
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
                      width: 250,
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
              onTap: () => _addToDraft(product),
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

  void _addToDraft(Product product) {
    ref.read(tableOrderProvider(widget.tableId).notifier).addToDraft(product, 1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} yeni siparişlere eklendi'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'GERI AL',
          onPressed: () {
            ref.read(tableOrderProvider(widget.tableId).notifier).removeFromDraft(product.id);
          },
        ),
      ),
    );
  }
}
