import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item.dart';
import 'order_status.dart';
import 'payment_method.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();
  const factory Order({
    required String id,
    required String orderNumber,
    required double totalAmount,
    required OrderStatus status,
    String? tableId,
    String? tableNumber,
    required List<OrderItem> items,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? discountAmount,
    String? customerNote,
    PaymentMethod? paymentMethod,
    Map<String, dynamic>? metadata,
    String? currentOrderId,
    @Default(false) bool isNew,
    @JsonKey(name: 'request_id') String? requestId,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) =>
      _$OrderFromJson(json);

  static const empty = Order(
    id: '',
    orderNumber: '',
    totalAmount: 0,
    status: OrderStatus.pending,
    items: [],
    createdAt: null,
  );

  @JsonKey(ignore: true)
  double get finalAmount => totalAmount;

  static Future<Order> fromJsonAsync(
    Map<String, dynamic> json,
    Future<List<OrderItem>> Function(String) getItems,
  ) async {
    final o = Order.fromJson(json);
    final items = await getItems(o.id);
    return o.copyWith(items: items);
  }
} 