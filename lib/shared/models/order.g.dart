// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: _idAsString(json, 'id') as String,
  orderNumber: json['order_number'] as String,
  totalAmount: _doubleFromJson(json['total']),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  tableId: json['table_id'] as String?,
  tableNumber: json['table_number'] as String?,
  items: json['items'] == null ? [] : _itemsFromJson(json['items']),
  userId: json['user_id'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  discountAmount: (json['discount_amount'] as num?)?.toDouble(),
  customerNote: json['customer_note'] as String?,
  paymentMethod: $enumDecodeNullable(
    _$PaymentMethodEnumMap,
    json['payment_method'],
  ),
  metadata: json['metadata'] as Map<String, dynamic>?,
  currentOrderId: json['current_order_id'] as String?,
  isNew: json['is_new'] as bool? ?? false,
  requestId: json['request_id'] as String?,
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_number': instance.orderNumber,
      'total': _doubleToJson(instance.totalAmount),
      'status': _$OrderStatusEnumMap[instance.status]!,
      'table_id': instance.tableId,
      'table_number': instance.tableNumber,
      'items': _itemsToJson(instance.items),
      'user_id': instance.userId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'discount_amount': instance.discountAmount,
      'customer_note': instance.customerNote,
      'payment_method': _$PaymentMethodEnumMap[instance.paymentMethod],
      'metadata': instance.metadata,
      'current_order_id': instance.currentOrderId,
      'is_new': instance.isNew,
      'request_id': instance.requestId,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.paymentPending: 'paymentPending',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
};
