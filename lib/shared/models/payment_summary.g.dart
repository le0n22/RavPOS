// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentSummaryImpl _$$PaymentSummaryImplFromJson(Map<String, dynamic> json) =>
    _$PaymentSummaryImpl(
      totalPayments: (json['totalPayments'] as num).toDouble(),
      totalRefunds: (json['totalRefunds'] as num).toDouble(),
      paymentsByMethod: (json['paymentsByMethod'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      averagePayment: (json['averagePayment'] as num).toDouble(),
    );

Map<String, dynamic> _$$PaymentSummaryImplToJson(
  _$PaymentSummaryImpl instance,
) => <String, dynamic>{
  'totalPayments': instance.totalPayments,
  'totalRefunds': instance.totalRefunds,
  'paymentsByMethod': instance.paymentsByMethod,
  'averagePayment': instance.averagePayment,
};
