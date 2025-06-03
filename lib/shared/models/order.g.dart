// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  tableId: json['tableId'] as String?,
  userId: json['userId'] as String?,
  orderNumber: json['orderNumber'] as String,
  tableNumber: json['tableNumber'] as String?,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: _orderStatusFromJson(json['status'] as String),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  customerNote: json['customerNote'] as String?,
  discountAmount: (json['discountAmount'] as num?)?.toDouble(),
  paymentMethod: _paymentMethodFromJson(json['paymentMethod'] as String?),
  metadata: json['metadata'] as Map<String, dynamic>?,
  currentOrderId: json['current_order_id'] as String?,
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableId': instance.tableId,
      'userId': instance.userId,
      'orderNumber': instance.orderNumber,
      'tableNumber': instance.tableNumber,
      'items': instance.items,
      'status': _orderStatusToJson(instance.status),
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'customerNote': instance.customerNote,
      'discountAmount': instance.discountAmount,
      'paymentMethod': _paymentMethodToJson(instance.paymentMethod),
      'metadata': instance.metadata,
      'current_order_id': instance.currentOrderId,
    };
