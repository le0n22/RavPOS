import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_report.freezed.dart';
part 'table_report.g.dart';

@freezed
class TableReport with _$TableReport {
  const factory TableReport({
    required String tableNumber,
    @Default(0) int orderCount,
    @Default(0.0) double totalSales,
  }) = _TableReport;

  factory TableReport.fromJson(Map<String, dynamic> json) => _$TableReportFromJson(json);
} 