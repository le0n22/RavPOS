import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String productId,
    required String productName,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    String? specialInstructions,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: (json['id'] ?? '').toString(),
    productId: (json['productId'] ?? json['product_id'] ?? '').toString(),
    productName: (json['productName'] ?? json['product_name'] ?? '').toString(),
    quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    unitPrice: (json['unitPrice'] ?? json['price'] ?? 0) is num ? (json['unitPrice'] ?? json['price'] ?? 0).toDouble() : 0.0,
    totalPrice: num.tryParse((json['totalPrice'] ?? json['total_price']).toString())?.toDouble() ?? 0,
    specialInstructions: json['specialInstructions'] as String?,
  );
} 