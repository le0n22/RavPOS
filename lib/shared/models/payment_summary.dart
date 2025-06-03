import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_summary.freezed.dart';
part 'payment_summary.g.dart';

@freezed
class PaymentSummary with _$PaymentSummary {
  const factory PaymentSummary({
    required double totalPayments,
    required double totalRefunds,
    required Map<String, double> paymentsByMethod,
    required double averagePayment,
  }) = _PaymentSummary;

  factory PaymentSummary.fromJson(Map<String, dynamic> json) => _$PaymentSummaryFromJson(json);
} 