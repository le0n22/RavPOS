// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardDataImpl _$$DashboardDataImplFromJson(Map<String, dynamic> json) =>
    _$DashboardDataImpl(
      todaySales: (json['todaySales'] as num?)?.toDouble() ?? 0,
      todayOrderCount: (json['todayOrderCount'] as num?)?.toInt() ?? 0,
      pendingOrdersCount: (json['pendingOrdersCount'] as num?)?.toInt() ?? 0,
      totalProductsCount: (json['totalProductsCount'] as num?)?.toInt() ?? 0,
      totalCategoriesCount:
          (json['totalCategoriesCount'] as num?)?.toInt() ?? 0,
      recentOrders:
          (json['recentOrders'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashboardDataImplToJson(_$DashboardDataImpl instance) =>
    <String, dynamic>{
      'todaySales': instance.todaySales,
      'todayOrderCount': instance.todayOrderCount,
      'pendingOrdersCount': instance.pendingOrdersCount,
      'totalProductsCount': instance.totalProductsCount,
      'totalCategoriesCount': instance.totalCategoriesCount,
      'recentOrders': instance.recentOrders,
    };
