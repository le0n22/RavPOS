import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item.dart';
import 'order_status.dart';
import 'payment_method.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const Order._();
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Order({
    @JsonKey(readValue: _idAsString) required String id,
    required String orderNumber,
    @JsonKey(
      name: 'total',
      fromJson: _doubleFromJson,
      toJson: _doubleToJson,
    )
    required double totalAmount,
    required OrderStatus status,
    String? tableId,
    String? tableNumber,
    @JsonKey(
      name: 'items',
      defaultValue: <OrderItem>[],
      fromJson: _itemsFromJson,
      toJson: _itemsToJson,
    )
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

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

String _idAsString(Map json, String key) =>
    json[key]?.toString() ?? '';

double _doubleFromJson(dynamic value) =>
    value == null ? 0 : double.tryParse(value.toString()) ?? 0;

dynamic _doubleToJson(double value) => value;

List<OrderItem> _itemsFromJson(dynamic value) =>
    (value as List<dynamic>?)
        ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList() ??
    const <OrderItem>[];

dynamic _itemsToJson(List<OrderItem> value) =>
    value.map((e) => e.toJson()).toList(); 