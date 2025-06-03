// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sales.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductSalesImpl _$$ProductSalesImplFromJson(Map<String, dynamic> json) =>
    _$ProductSalesImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      totalQuantitySold: (json['totalQuantitySold'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductSalesImplToJson(_$ProductSalesImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'totalQuantitySold': instance.totalQuantitySold,
      'totalRevenue': instance.totalRevenue,
    };
