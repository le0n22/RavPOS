// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportDataImpl _$$ReportDataImplFromJson(Map<String, dynamic> json) =>
    _$ReportDataImpl(
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      averageOrderValue: (json['averageOrderValue'] as num?)?.toDouble() ?? 0.0,
      totalDiscountGiven:
          (json['totalDiscountGiven'] as num?)?.toDouble() ?? 0.0,
      salesByPaymentMethod:
          (json['salesByPaymentMethod'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      topSellingProducts:
          (json['topSellingProducts'] as List<dynamic>?)
              ?.map((e) => ProductSales.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailySalesData:
          (json['dailySalesData'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(DateTime.parse(k), (e as num).toDouble()),
          ) ??
          const {},
      isLoading: json['isLoading'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
      orders:
          (json['orders'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hourlyOrderCounts:
          (json['hourlyOrderCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
          ) ??
          const {},
      tableReports:
          (json['tableReports'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, TableReport.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ReportDataImplToJson(_$ReportDataImpl instance) =>
    <String, dynamic>{
      'totalSales': instance.totalSales,
      'totalOrders': instance.totalOrders,
      'averageOrderValue': instance.averageOrderValue,
      'totalDiscountGiven': instance.totalDiscountGiven,
      'salesByPaymentMethod': instance.salesByPaymentMethod,
      'topSellingProducts': instance.topSellingProducts,
      'dailySalesData': instance.dailySalesData.map(
        (k, e) => MapEntry(k.toIso8601String(), e),
      ),
      'isLoading': instance.isLoading,
      'errorMessage': instance.errorMessage,
      'orders': instance.orders,
      'hourlyOrderCounts': instance.hourlyOrderCounts.map(
        (k, e) => MapEntry(k.toString(), e),
      ),
      'tableReports': instance.tableReports,
    };
