import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required double amount,
    required String method,
    @Default(0) double discount,
    @Default(0) double received,
    @Default(0) double change,
    @Default(false) bool refunded,
    required DateTime createdAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
} 