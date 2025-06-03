import 'package:dio/dio.dart';
import 'package:ravpos/core/network/api_service.dart';
import 'package:ravpos/shared/models/order.dart';
import 'package:ravpos/shared/models/order_item.dart';
import 'package:ravpos/shared/models/order_status.dart';
import 'package:ravpos/core/storage/storage_factory.dart';
import 'package:ravpos/core/storage/storage_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ravpos/shared/models/report_data.dart';
import 'package:ravpos/shared/models/online_order.dart';
import 'package:ravpos/shared/models/payment.dart';
import 'package:ravpos/shared/models/payment_summary.dart';

class OrderRepository {
  final ApiService apiService;

  OrderRepository(this.apiService);

  Future<List<Order>> getAllOrders() async {
    final response = await apiService.get('/orders');
    final List<dynamic> data = response.data;
    final orders = await Future.wait(
      data.map((json) => Order.fromJsonAsync(json, getOrderItems)).toList(),
    );
    return orders;
  }

  Future<Order?> getOrderById(String id) async {
    final response = await apiService.get('/orders/$id');
    return await Order.fromJsonAsync(response.data, getOrderItems);
  }

  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    final response = await apiService.get('/orders', queryParameters: {'status': status.toString().split('.').last});
    final List<dynamic> data = response.data;
    return data.map((json) => Order.fromJson(json)).toList();
  }

  Future<String> insertOrder(Order order, List<OrderItem> items) async {
    final response = await apiService.post('/orders', data: order.toJson());
    final orderId = response.data['id'].toString();
    for (final item in items) {
      await insertOrderItem(orderId, item);
    }
    return orderId;
  }

  Future<int> updateOrder(Order order) async {
    final response = await apiService.put('/orders/${order.id}', data: order.toJson());
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<int> updateOrderStatus(String orderId, OrderStatus status) async {
    final response = await apiService.patch('/orders/$orderId/status', data: {'status': status.toString().split('.').last});
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<int> deleteOrder(String id) async {
    final response = await apiService.delete('/orders/$id');
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<List<Order>> getOrdersByTable(String tableIdentifier) async {
    final response = await apiService.get('/orders', queryParameters: {'table': tableIdentifier});
    final List<dynamic> data = response.data;
    final orders = await Future.wait(
      data.map((json) => Order.fromJsonAsync(json, getOrderItems)).toList(),
    );
    return orders;
  }

  Future<Order?> getLatestOrderByTable(String tableIdentifier) async {
    final response = await apiService.get('/orders/latest', queryParameters: {'table': tableIdentifier});
    if (response.data != null) {
      return Order.fromJson(response.data);
    }
    return null;
  }

  Future<List<OrderItem>> getOrderItems(String orderId) async {
    final response = await apiService.get('/orders/$orderId/items');
    final List<dynamic> data = response.data;
    return data.map((json) => OrderItem.fromJson(json)).toList();
  }

  Future<String> insertOrderItem(String orderId, OrderItem item) async {
    print('[DEBUG] Sipariş Kalemi Ekleniyor:');
    print('[DEBUG]   - Sipariş ID: $orderId');
    print('[DEBUG]   - Ürün ID: ${item.productId}');
    print('[DEBUG]   - Ürün Adı: ${item.productName}');
    print('[DEBUG]   - Miktar: ${item.quantity}');
    print('[DEBUG]   - Birim Fiyat: ${item.unitPrice}');
    print('[DEBUG]   - Toplam Fiyat: ${item.totalPrice}');

    final data = {
      'product_id': item.productId,
      'product_name': item.productName,
      'quantity': item.quantity,
      'price': item.unitPrice,
      'total_price': item.totalPrice,
    };
    
    print('[DEBUG] Gönderilen Veri: $data');

    final response = await apiService.post('/orders/$orderId/items', data: data);
    
    print('[DEBUG] Sunucu Yanıtı: ${response.data}');
    
    return response.data['id'].toString();
  }

  Future<int> updateOrderItem(String orderId, OrderItem item) async {
    final response = await apiService.put('/orders/$orderId/items/${item.id}', data: item.toJson());
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<int> deleteOrderItem(String orderId, String itemId) async {
    final response = await apiService.delete('/orders/$orderId/items/$itemId');
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<List<Order>> getCompletedOrdersByDateRange(DateTime start, DateTime end) async {
    final response = await apiService.get('/orders', queryParameters: {
      'status': 'delivered',
      'start': DateTime(start.year, start.month, start.day).toIso8601String(),
      'end': DateTime(end.year, end.month, end.day, 23, 59, 59).toIso8601String(),
    });
    final List<dynamic> data = response.data;
    return data.map((json) => Order.fromJson(json)).toList();
  }

  Future<ReportData> fetchSummaryReport(DateTime start, DateTime end) async {
    final response = await apiService.get('/reports/summary', queryParameters: {
      'start': DateTime(start.year, start.month, start.day).toIso8601String(),
      'end': DateTime(end.year, end.month, end.day, 23, 59, 59).toIso8601String(),
    });
    return ReportData.fromJson(response.data);
  }

  Future<List<OnlineOrder>> fetchOnlineOrders() async {
    final response = await apiService.get('/online-orders');
    final List<dynamic> data = response.data;
    return data.map((json) => OnlineOrder.fromJson(json)).toList();
  }

  Future<void> acceptOnlineOrder(String onlineOrderId) async {
    await apiService.post('/online-orders/$onlineOrderId/accept');
  }

  Future<void> rejectOnlineOrder(String onlineOrderId, String reason) async {
    await apiService.post('/online-orders/$onlineOrderId/reject', data: {'reason': reason});
  }

  Future<void> createPayment({
    required String orderId,
    required double amount,
    required String method,
    double discount = 0,
    double received = 0,
    double change = 0,
  }) async {
    await apiService.post('/payments', data: {
      'orderId': orderId,
      'amount': amount,
      'method': method,
      'discount': discount,
      'received': received,
      'change': change,
    });
  }

  Future<List<Payment>> fetchPayments(String orderId) async {
    final response = await apiService.get('/payments', queryParameters: {'orderId': orderId});
    final List<dynamic> data = response.data;
    return data.map((json) => Payment.fromJson(json)).toList();
  }

  Future<void> refundPayment(String paymentId) async {
    await apiService.post('/payments/$paymentId/refund');
  }

  Future<PaymentSummary> fetchPaymentSummary(DateTime from, DateTime to) async {
    final response = await apiService.get('/payments/summary', queryParameters: {
      'dateFrom': from.toIso8601String(),
      'dateTo': to.toIso8601String(),
    });
    return PaymentSummary.fromJson(response.data);
  }
} 