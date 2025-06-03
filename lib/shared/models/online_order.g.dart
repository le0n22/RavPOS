// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnlineOrderImpl _$$OnlineOrderImplFromJson(Map<String, dynamic> json) =>
    _$OnlineOrderImpl(
      onlineOrderId: json['onlineOrderId'] as String,
      platform: $enumDecode(_$OnlinePlatformEnumMap, json['platform']),
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerAddress: json['customerAddress'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      customerNote: json['customerNote'] as String?,
      isAccepted: json['isAccepted'] as bool? ?? false,
      isRejected: json['isRejected'] as bool? ?? false,
      rejectionReason: json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$$OnlineOrderImplToJson(_$OnlineOrderImpl instance) =>
    <String, dynamic>{
      'onlineOrderId': instance.onlineOrderId,
      'platform': _$OnlinePlatformEnumMap[instance.platform]!,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerAddress': instance.customerAddress,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'customerNote': instance.customerNote,
      'isAccepted': instance.isAccepted,
      'isRejected': instance.isRejected,
      'rejectionReason': instance.rejectionReason,
    };

const _$OnlinePlatformEnumMap = {
  OnlinePlatform.yemeksepeti: 'yemeksepeti',
  OnlinePlatform.trendyolYemek: 'trendyolYemek',
  OnlinePlatform.getirYemek: 'getirYemek',
  OnlinePlatform.website: 'website',
  OnlinePlatform.other: 'other',
};
