import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item.dart';
import 'order_status.dart';
import 'payment_method.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();  // Add this line to allow custom getters
  
  const factory Order({
    required String id,
    String? tableId,
    String? userId,
    required String orderNumber,
    String? tableNumber,
    required List<OrderItem> items,
    @JsonKey(
      fromJson: _orderStatusFromJson,
      toJson: _orderStatusToJson,
    )
    required OrderStatus status,
    required double totalAmount,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? customerNote,
    double? discountAmount,
    @JsonKey(
      fromJson: _paymentMethodFromJson,
      toJson: _paymentMethodToJson,
    )
    PaymentMethod? paymentMethod,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'current_order_id') String? currentOrderId,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: (json['id'] ?? '').toString(),
    tableId: (json['table_id'] == null || json['table_id'].toString().isEmpty) ? null : json['table_id'].toString(),
    userId: (json['user_id'] == null || json['user_id'].toString().isEmpty) ? null : json['user_id'].toString(),
    orderNumber: ((json['orderNumber'] ?? json['order_number'] ?? '').toString().replaceAll(RegExp('^#+'), '#')),
    tableNumber: (json['tableNumber'] ?? json['table_number'])?.toString(),
    items: (json['items'] as List<dynamic>?)?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    status: _orderStatusFromJson((json['status'] ?? 'pending').toString()),
    totalAmount: double.tryParse((json['total'] ?? json['totalAmount'] ?? '0').toString()) ?? 0.0,
    createdAt: DateTime.parse(json['created_at'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : (json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null),
    customerNote: json['customerNote'] as String?,
    discountAmount: (json['discountAmount'] as num?)?.toDouble(),
    paymentMethod: _paymentMethodFromJson(json['paymentMethod'] as String?),
    metadata: json['metadata'] as Map<String, dynamic>?,
    currentOrderId: (json['currentOrderId'] ?? json['current_order_id'])?.toString(),
  );
  
  /// Get final amount after discount
  double get finalAmount => totalAmount - (discountAmount ?? 0);

  /// Asenkron olarak Order nesnesi oluşturur ve eğer items boşsa, API'den ürünleri çeker.
  static Future<Order> fromJsonAsync(Map<String, dynamic> json, Future<List<OrderItem>> Function(String orderId) fetchItems) async {
    final order = Order.fromJson(json);
    if (order.items.isEmpty && order.id.isNotEmpty) {
      final items = await fetchItems(order.id);
      return order.copyWith(items: items);
    }
    return order;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'table_id': tableId,
      'user_id': userId,
      'orderNumber': orderNumber,
      'tableNumber': tableNumber,
      'items': items.map((e) => e.toJson()).toList(),
      'status': status.name,
      'total': totalAmount, // Backend için
      'totalAmount': totalAmount, // Flutter için
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'customerNote': customerNote,
      'discountAmount': discountAmount,
      'paymentMethod': paymentMethod?.name,
      'metadata': metadata,
      'currentOrderId': currentOrderId,
      'current_order_id': currentOrderId,
    };
    return data;
  }

  // Sentinel empty order for use as a placeholder when no real order exists
  static final Order empty = Order(
    id: '',
    orderNumber: '',
    items: const [],
    status: OrderStatus.pending,
    totalAmount: 0.0,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  );
}

OrderStatus _orderStatusFromJson(String status) => OrderStatusExtension.fromString(status);
String _orderStatusToJson(OrderStatus status) => status.name;

PaymentMethod? _paymentMethodFromJson(String? method) => 
    method != null ? PaymentMethodExtension.fromString(method) : null;
String? _paymentMethodToJson(PaymentMethod? method) => method?.name; 