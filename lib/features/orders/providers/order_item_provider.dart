import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/order_item.dart';
import '../../../core/database/repositories/order_repository.dart';
import '../../../core/network/api_service.dart';

final orderItemRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return OrderRepository(apiService);
});

class OrderItemNotifier extends AutoDisposeFamilyAsyncNotifier<List<OrderItem>, String> {
  late final OrderRepository _repository;

  @override
  Future<List<OrderItem>> build(String orderId) async {
    _repository = ref.read(orderItemRepositoryProvider);
    return loadOrderItems(orderId);
  }

  Future<List<OrderItem>> loadOrderItems(String orderId) async {
    try {
      state = const AsyncLoading();
      final items = await _repository.getOrderItems(orderId);
      state = AsyncData(items);
      return items;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<bool> addOrderItem(String orderId, OrderItem item) async {
    try {
      final id = await _repository.insertOrderItem(orderId, item);
      if (id.isNotEmpty) {
        await loadOrderItems(orderId);
        return true;
      }
      return false;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateOrderItem(String orderId, OrderItem item) async {
    try {
      final result = await _repository.updateOrderItem(orderId, item);
      if (result) {
        await loadOrderItems(orderId);
        return true;
      }
      return false;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteOrderItem(String orderId, String itemId) async {
    try {
      final result = await _repository.deleteOrderItem(orderId, itemId);
      if (result) {
        await loadOrderItems(orderId);
        return true;
      }
      return false;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

final orderItemProvider = AutoDisposeAsyncNotifierProviderFamily<OrderItemNotifier, List<OrderItem>, String>(
  OrderItemNotifier.new,
); 