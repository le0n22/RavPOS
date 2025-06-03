import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/dashboard_data.dart';
import '../../../shared/models/order.dart';
import '../../../shared/models/order_status.dart';
import '../../../core/database/repositories/order_repository.dart';
import '../../../core/database/repositories/product_repository.dart';
import '../../../core/database/repositories/category_repository.dart';
import '../../../shared/providers/providers.dart';

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  late final OrderRepository _orderRepository;
  late final ProductRepository _productRepository;
  late final CategoryRepository _categoryRepository;

  @override
  Future<DashboardData> build() async {
    _orderRepository = ref.read(orderRepositoryProvider);
    _productRepository = ProductRepository(ref.read(apiServiceProvider));
    _categoryRepository = CategoryRepository(ref.read(apiServiceProvider));
    
    return loadDashboardData();
  }

  Future<DashboardData> loadDashboardData() async {
    state = const AsyncLoading();
    try {
      // Fetch all orders and filter today's orders
      final allOrders = await _orderRepository.getAllOrders();
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      final todaysOrders = allOrders.where((order) {
        return order.createdAt.isAfter(startOfDay) && order.createdAt.isBefore(endOfDay);
      }).toList();
      final products = await _productRepository.getAllProducts();
      final categories = await _categoryRepository.getCategories();
      final pendingOrders = await _orderRepository.getOrdersByStatus(OrderStatus.pending);
      
      // Calculate statistics
      final todaySales = todaysOrders.fold(0.0, (sum, order) => sum + order.totalAmount);
      
      // Create dashboard data
      final dashboardData = DashboardData(
        todaySales: todaySales,
        todayOrderCount: todaysOrders.length,
        pendingOrdersCount: pendingOrders.length,
        totalProductsCount: products.length,
        totalCategoriesCount: categories.length,
        recentOrders: todaysOrders.take(5).toList(),
      );
      
      return dashboardData;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return const DashboardData();
    }
  }

  Future<List<Order>> getRecentOrders() async {
    final currentState = state;
    if (currentState is AsyncData<DashboardData>) {
      return currentState.value.recentOrders;
    } else {
      await loadDashboardData();
      final newState = state;
      if (newState is AsyncData<DashboardData>) {
        return newState.value.recentOrders;
      }
    }
    return [];
  }

  Future<DashboardData> getTodaysStats() async {
    return loadDashboardData();
  }
}

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardData>(
  () => DashboardNotifier(),
); 