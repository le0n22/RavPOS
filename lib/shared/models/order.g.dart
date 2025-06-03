// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  orderNumber: json['orderNumber'] as String,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  tableId: json['tableId'] as String?,
  tableNumber: json['tableNumber'] as String?,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  userId: json['userId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  discountAmount: (json['discountAmount'] as num?)?.toDouble(),
  customerNote: json['customerNote'] as String?,
  paymentMethod: $enumDecodeNullable(
    _$PaymentMethodEnumMap,
    json['paymentMethod'],
  ),
  metadata: json['metadata'] as Map<String, dynamic>?,
  currentOrderId: json['currentOrderId'] as String?,
  isNew: json['isNew'] as bool? ?? false,
  requestId: json['request_id'] as String?,
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'totalAmount': instance.totalAmount,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'tableId': instance.tableId,
      'tableNumber': instance.tableNumber,
      'items': instance.items,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'discountAmount': instance.discountAmount,
      'customerNote': instance.customerNote,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod],
      'metadata': instance.metadata,
      'currentOrderId': instance.currentOrderId,
      'isNew': instance.isNew,
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
