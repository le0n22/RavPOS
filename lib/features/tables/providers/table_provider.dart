import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/core/database/repositories/table_repository.dart';
// import 'package:ravpos/core/database/repositories/order_repository.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:ravpos/core/network/api_service.dart';

// Repository provider
final tableRepositoryProvider = Provider<TableRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return TableRepository(apiService);
});

// Table state notifier provider
final tableProvider = AsyncNotifierProvider<TableNotifier, List<RestaurantTable>>(() {
  return TableNotifier();
});

// Table provider for a specific table
final tableByIdProvider = Provider.family<AsyncValue<RestaurantTable?>, String>((ref, tableId) {
  final tablesAsync = ref.watch(tableProvider);
  return tablesAsync.when(
    data: (tables) {
      final table = tables.where((table) => table.id == tableId).firstOrNull;
      return AsyncValue.data(table);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

class TableNotifier extends AsyncNotifier<List<RestaurantTable>> {
  // TODO: Implement OrderRepository for backend API integration
  // late final OrderRepository _orderRepository;
  // _orderRepository = OrderRepository();
  // Replace usages of _orderRepository.getOrderById with a placeholder or mock implementation for now.
  
  @override
  Future<List<RestaurantTable>> build() async {
    // TODO: Implement OrderRepository for backend API integration
    // _orderRepository = OrderRepository();
    return loadTables();
  }

  // Repository getter
  TableRepository get _repository => ref.read(tableRepositoryProvider);

  // Load all tables with current order information
  Future<List<RestaurantTable>> loadTables() async {
    try {
      final tables = await _repository.getTables();
      
      // For each table, update order information if it has a current order
      for (int i = 0; i < tables.length; i++) {
        final table = tables[i];
        if (table.currentOrderId != null && table.currentOrderId!.isNotEmpty) {
          // Get the order to update total amount
          // final order = await _orderRepository.getOrderById(table.currentOrderId!);
          // if (order != null) {
          //   // Update table with current order information
          //   tables[i] = table.copyWith(
          //     currentOrderTotal: order.totalAmount,
          //     // Update status based on order status
          //     status: _getTableStatusFromOrder(order.status),
          //   );
          // } else {
          //   // Order not found - clear reference and set to available
          //   await _repository.updateTable(table.copyWith(
          //     currentOrderId: null,
          //     currentOrderTotal: 0.0,
          //     status: TableStatus.available,
          //   ));
          //   tables[i] = table.copyWith(
          //     currentOrderId: null,
          //     currentOrderTotal: 0.0,
          //     status: TableStatus.available,
          //   );
          // }
        }
      }
      
      return tables;
    } catch (e) {
      throw Exception('Failed to load tables: $e');
    }
  }

  // Determine table status based on order status
  TableStatus _getTableStatusFromOrder(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.pending:
      case OrderStatus.preparing:
      case OrderStatus.ready:
        return TableStatus.occupied;
      case OrderStatus.paymentPending:
        return TableStatus.paymentPending;
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
        return TableStatus.available;
      default:
        return TableStatus.available;
    }
  }

  // Update an existing table
  Future<bool> updateTable(RestaurantTable table) async {
    try {
      await _repository.updateTable(table);
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => loadTables());
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Add a new table
  Future<bool> addTable(RestaurantTable table) async {
    try {
      final id = await _repository.addTable(table);
      if (id.isNotEmpty) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => loadTables());
        return true;
      }
      return false;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Delete a table
  Future<bool> deleteTable(String tableId) async {
    try {
      final result = await _repository.deleteTable(tableId);
      if (result > 0) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => loadTables());
        return true;
      }
      return false;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Update table status
  Future<void> updateTableStatus(String tableId, TableStatus status, {String? currentOrderId}) async {
    try {
      await _repository.updateTableStatus(
        tableId,
        status,
        currentOrderId: currentOrderId,
      );
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => loadTables());
      print('🟠 CURRENT STATE AFTER UPDATE:');
      state.whenData((tables) => tables.forEach(print));
    } catch (e) {
      print('🔴 TABLE UPDATE ERROR: \\${e}');
      rethrow;
    }
  }

  // Get tables by category
  Future<List<RestaurantTable>> getTablesByCategory(String category) async {
    try {
      final tables = await _repository.getTables();
      return tables.where((table) => table.category == category).toList();
    } catch (e) {
      return [];
    }
  }

  // Get a table by ID
  Future<RestaurantTable?> getTableById(String tableId) async {
    try {
      return await _repository.getTableById(tableId);
    } catch (e) {
      return null;
    }
  }
  
  // Get tables by status
  // TODO: Implement getTablesByStatus in TableRepository if needed in the future.
  // Future<List<RestaurantTable>> getTablesByStatus(TableStatus status) async {
  //   try {
  //     return await _repository.getTablesByStatus(status);
  //   } catch (e) {
  //     print('Error getting tables by status: $e');
  //     return [];
  //   }
  // }

  // Stream tables (for real-time updates)
  Stream<List<RestaurantTable>> streamTables() async* {
    while (true) {
      yield await _repository.getTables();
      await Future.delayed(const Duration(seconds: 5)); // Poll every 5 seconds
    }
  }
} 