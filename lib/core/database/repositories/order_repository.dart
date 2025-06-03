import 'package:dio/dio.dart';
import 'package:ravpos/shared/models/order.dart';
import 'package:ravpos/shared/models/order_item.dart';
import 'package:ravpos/core/network/api_service.dart';
import 'package:ravpos/shared/models/order_status.dart';
import 'package:flutter/foundation.dart';

class OrderRepository {
  final ApiService api;
  OrderRepository(this.api);

  Dio get dio => api.dio;

  Future<List<Order>> getAllOrders() async {
    final resp = await dio.get('/orders');
    final List data = resp.data;
    final orders = await Future.wait(
      data.map((json) async {
        final order = Order.fromJson(json as Map<String, dynamic>);
        final items = await getOrderItems(order.id);
        return order.copyWith(items: items);
      }),
    );
    return orders;
  }

  Future<Order> getOrder(String id) async {
    final resp = await dio.get('/orders/$id');
    final order = Order.fromJson(resp.data as Map<String, dynamic>);
    final items = await getOrderItems(order.id);
    return order.copyWith(items: items);
  }

  Future<List<OrderItem>> getOrderItems(String orderId) async {
    final resp = await dio.get('/orders/$orderId/items');
    final List<dynamic> data = resp.data;
    return data.map((json) => OrderItem.fromJson(json as Map<String, dynamic>)).toList();
  }

  // ---- legacy stubs, TODO: implement properly ----
  Future<Order> getOrderById(String id) async =>
      throw UnimplementedError('getOrderById not yet migrated');

  Future<List<Order>> getOrdersByTable(String tableId) async =>
      throw UnimplementedError('getOrdersByTable not yet migrated');

  Future<List<Order>> getOrdersByStatus(OrderStatus status) async =>
      throw UnimplementedError('getOrdersByStatus not yet migrated');

  /// Creates a new order (atomic) and returns the created Order.
  Future<Order?> insertOrder(Order draft, List<OrderItem> items) async {
    try {
      final payload = {
        'table_id' : draft.tableId,
        'user_id'  : draft.userId,
        'orderNumber': draft.orderNumber,
        'status'   : draft.status.name,
        'total'    : draft.totalAmount,
        'items'    : items
            .map((i) => {
                  'productId'  : i.productId,
                  'productName': i.productName,
                  'quantity'   : i.quantity,
                  'price'      : i.unitPrice,
                  'totalPrice' : i.totalPrice,
                })
            .toList(),
      };

      final resp = await api.dio.post('/orders', data: payload);
      final data = resp.data;

      final order = Order.fromJson({
        ...data['order'],
        'items': data['items'],
      });

      return order;
    } catch (e, st) {
      debugPrint('insertOrder error: $e\n$st');
      return null; // caller handles null ⇒ failure
    }
  }

  Future<bool> updateOrder(Order order,
      {List<OrderItem>? items}) async =>
      throw UnimplementedError('updateOrder not yet migrated');

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async =>
      throw UnimplementedError('updateOrderStatus not yet migrated');

  Future<bool> deleteOrder(String orderId) async =>
      throw UnimplementedError('deleteOrder not yet migrated');

  // online-orders & reports
  Future<List<Order>> fetchOnlineOrders() async =>
      throw UnimplementedError('online orders not yet migrated');

  Future<void> acceptOnlineOrder(String id) async =>
      throw UnimplementedError('acceptOnlineOrder');

  Future<void> rejectOnlineOrder(String id, String reason) async =>
      throw UnimplementedError('rejectOnlineOrder');

  Future<List<Order>> getCompletedOrdersByDateRange(
          DateTime start, DateTime end) async =>
      throw UnimplementedError('getCompletedOrdersByDateRange');

  Future<Map<String, dynamic>> fetchSummaryReport(
          DateTime start, DateTime end) async =>
      throw UnimplementedError('fetchSummaryReport');

  Future<String> insertOrderItem(String orderId, OrderItem item) async =>
      throw UnimplementedError('insertOrderItem');

  Future<bool> updateOrderItem(
          String orderId, OrderItem item) async =>
      throw UnimplementedError('updateOrderItem');

  Future<bool> deleteOrderItem(
          String orderId, String itemId) async =>
      throw UnimplementedError('deleteOrderItem');
} 