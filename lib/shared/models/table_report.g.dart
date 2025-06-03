// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableReportImpl _$$TableReportImplFromJson(Map<String, dynamic> json) =>
    _$TableReportImpl(
      tableNumber: json['tableNumber'] as String,
      orderCount: (json['orderCount'] as num?)?.toInt() ?? 0,
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TableReportImplToJson(_$TableReportImpl instance) =>
    <String, dynamic>{
      'tableNumber': instance.tableNumber,
      'orderCount': instance.orderCount,
      'totalSales': instance.totalSales,
    };
