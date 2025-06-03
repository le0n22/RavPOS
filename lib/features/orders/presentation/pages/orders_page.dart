import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/order_status.dart';
import '../../../../core/router/app_router.dart';
import '../../providers/order_provider.dart';
import '../widgets/order_column.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> with AutomaticKeepAliveClientMixin {
  Timer? _refreshTimer;
  final ScrollController _scrollController = ScrollController();
  
  // Filter state
  bool _showFilterMenu = false;
  String? _tableFilter;
  String? _searchQuery;
  String _sortBy = 'time'; // 'time', 'amount', 'table'
  
  @override
  bool get wantKeepAlive => true; // Keep state when navigating
  
  @override
  void initState() {
    super.initState();
    
    // Set up periodic refresh - but don't start loading yet
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _scheduleOrdersLoad();
    });
    
    // Initial load after widget initialization
    Future.microtask(() {
      ref.read(orderProvider.notifier).loadOrders();
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule a refresh when the page becomes visible again
    Future.microtask(() {
      final ordersAsync = ref.read(orderProvider);
      if (ordersAsync is AsyncData && ordersAsync.value?.isEmpty == true) {
        ref.read(orderProvider.notifier).loadOrders();
      }
    });
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
  
  // Schedule loading orders outside of the build phase
  void _scheduleOrdersLoad() {
    // Use Future.microtask to ensure this happens after the build phase
    Future.microtask(() {
      if (mounted) {
        // Force refresh to ensure we get the latest data
        ref.read(orderProvider.notifier).forceRefresh();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Get orders from provider
    final ordersAsync = ref.watch(orderProvider);
    
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(orderProvider.notifier).loadOrders();
          // Wait a bit to ensure the refresh indicator shows
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ordersAsync.when(
          data: (orders) => _buildOrdersKanban(orders),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _buildErrorView(error),
        ),
      ),
      floatingActionButton: _buildNewOrderFAB(context),
    );
  }
  
  // Build the app bar with title and action buttons
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Siparişler'),
      actions: [
        // Manual migration button
        IconButton(
          icon: const Icon(Icons.link),
          tooltip: 'Tüm Bağsız Siparişleri Takeout Masasına Bağla',
          onPressed: () async {
            final result = await ref.read(orderProvider.notifier).migrateUnlinkedOrdersToTakeout();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result ? 'Bağsız siparişler Takeout masasına bağlandı!' : 'Hiç bağsız sipariş yok veya hata oluştu.')),
              );
              // Refresh orders
              ref.read(orderProvider.notifier).loadOrders();
            }
          },
        ),
        // Refresh button
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _scheduleOrdersLoad,
          tooltip: 'Yenile',
        ),
        
        // Filter button
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filtrele',
          onSelected: (value) {
            if (value == 'filter_table') {
              // Show table filter dialog
              _showTableFilterDialog();
            } else if (value == 'filter_clear') {
              setState(() {
                _tableFilter = null;
                _searchQuery = null;
              });
            } else if (value.startsWith('sort_')) {
              setState(() {
                _sortBy = value.replaceFirst('sort_', '');
              });
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'filter_table',
              child: Text('Masaya Göre Filtrele'),
            ),
            const PopupMenuItem(
              value: 'sort_time',
              child: Text('Zamana Göre Sırala'),
            ),
            const PopupMenuItem(
              value: 'sort_amount',
              child: Text('Tutara Göre Sırala'),
            ),
            const PopupMenuItem(
              value: 'sort_table',
              child: Text('Masa Numarasına Göre Sırala'),
            ),
            if (_tableFilter != null || _searchQuery != null)
              const PopupMenuItem(
                value: 'filter_clear',
                child: Text('Filtreleri Temizle'),
              ),
          ],
        ),
        
        // Search button
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _showSearchDialog();
          },
          tooltip: 'Ara',
        ),
      ],
    );
  }
  
  // Build the main Kanban board with horizontal scrollable columns
  Widget _buildOrdersKanban(List<Order> allOrders) {
    // Filter orders if needed
    final filteredOrders = _filterOrders(allOrders);
    
    // Sort orders based on selected criterion
    final sortedOrders = _sortOrders(filteredOrders);
    
    // Group orders by status
    final pendingOrders = sortedOrders.where((order) => order.status == OrderStatus.pending).toList();
    final preparingOrders = sortedOrders.where((order) => order.status == OrderStatus.preparing).toList();
    final readyOrders = sortedOrders.where((order) => order.status == OrderStatus.ready).toList();
    final deliveredOrders = sortedOrders.where((order) => order.status == OrderStatus.delivered).toList();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          color: Colors.grey.shade200,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: constraints.maxHeight,
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pending column
                  OrderColumn(
                    status: OrderStatus.pending,
                    orders: pendingOrders,
                  ),
                  
                  // Preparing column
                  OrderColumn(
                    status: OrderStatus.preparing,
                    orders: preparingOrders,
                  ),
                  
                  // Ready column
                  OrderColumn(
                    status: OrderStatus.ready,
                    orders: readyOrders,
                  ),
                  
                  // Delivered column
                  OrderColumn(
                    status: OrderStatus.delivered,
                    orders: deliveredOrders,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  // Filter orders based on current filter settings
  List<Order> _filterOrders(List<Order> orders) {
    // First exclude delivered orders
    orders = orders.where((order) => order.status != OrderStatus.delivered).toList();
    
    if (_tableFilter != null) {
      orders = orders.where((order) => order.tableNumber == _tableFilter).toList();
    }
    
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      orders = orders.where((order) => 
        order.orderNumber.contains(_searchQuery!) || 
        order.items.any((item) => item.productName.toLowerCase().contains(_searchQuery!.toLowerCase()))
      ).toList();
    }
    
    return orders;
  }
  
  // Sort orders based on selected criterion
  List<Order> _sortOrders(List<Order> orders) {
    switch (_sortBy) {
      case 'time':
        return orders..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case 'amount':
        return orders..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
      case 'table':
        return orders..sort((a, b) {
          if (a.tableNumber == null) return 1;
          if (b.tableNumber == null) return -1;
          return a.tableNumber!.compareTo(b.tableNumber!);
        });
      default:
        return orders;
    }
  }
  
  // Build error view when loading orders fails
  Widget _buildErrorView(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Siparişler yüklenirken bir hata oluştu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _scheduleOrdersLoad,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
  
  // Build New Order floating action button
  FloatingActionButton? _buildNewOrderFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        // Navigate to tables page to select a table for the new order
        context.go('/tables');
      },
      icon: const Icon(Icons.restaurant),
      label: const Text('Masaları Görüntüle'),
      tooltip: 'Sipariş başlatmak için masa seçin',
    );
  }
  
  // Show table filter dialog
  void _showTableFilterDialog() {
    // TODO: Implement actual table list from a repository
    final tables = List.generate(10, (index) => (index + 1).toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Masaya Göre Filtrele'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];
              return ListTile(
                title: Text('Masa $table'),
                selected: _tableFilter == table,
                leading: _tableFilter == table
                    ? const Icon(Icons.radio_button_checked)
                    : const Icon(Icons.radio_button_unchecked),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _tableFilter = table;
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('İptal'),
          ),
          if (_tableFilter != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _tableFilter = null;
                });
              },
              child: const Text('Filtreyi Temizle'),
            ),
        ],
      ),
    );
  }
  
  // Show search dialog
  void _showSearchDialog() {
    final TextEditingController controller = TextEditingController(text: _searchQuery);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sipariş Ara'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Sipariş numarası veya ürün adı',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) {
            Navigator.of(context).pop();
            setState(() {
              _searchQuery = value.isEmpty ? null : value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _searchQuery = controller.text.isEmpty ? null : controller.text;
              });
            },
            child: const Text('Ara'),
          ),
        ],
      ),
    );
  }
} 