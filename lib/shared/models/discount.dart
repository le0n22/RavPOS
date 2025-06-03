import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount.freezed.dart';
part 'discount.g.dart';

enum DiscountType { percentage, fixed }

@freezed
class Discount with _$Discount {
  const factory Discount({
    required String id,
    required String name,
    required DiscountType type,
    required double value,
    DateTime? startDate,
    DateTime? endDate,
    @Default(true) bool isActive,
    String? description,
  }) = _Discount;

  factory Discount.fromJson(Map<String, dynamic> json) => _$DiscountFromJson(json);
} 