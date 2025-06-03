// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentSummary _$PaymentSummaryFromJson(Map<String, dynamic> json) {
  return _PaymentSummary.fromJson(json);
}

/// @nodoc
mixin _$PaymentSummary {
  double get totalPayments => throw _privateConstructorUsedError;
  double get totalRefunds => throw _privateConstructorUsedError;
  Map<String, double> get paymentsByMethod =>
      throw _privateConstructorUsedError;
  double get averagePayment => throw _privateConstructorUsedError;

  /// Serializes this PaymentSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentSummaryCopyWith<PaymentSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentSummaryCopyWith<$Res> {
  factory $PaymentSummaryCopyWith(
    PaymentSummary value,
    $Res Function(PaymentSummary) then,
  ) = _$PaymentSummaryCopyWithImpl<$Res, PaymentSummary>;
  @useResult
  $Res call({
    double totalPayments,
    double totalRefunds,
    Map<String, double> paymentsByMethod,
    double averagePayment,
  });
}

/// @nodoc
class _$PaymentSummaryCopyWithImpl<$Res, $Val extends PaymentSummary>
    implements $PaymentSummaryCopyWith<$Res> {
  _$PaymentSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPayments = null,
    Object? totalRefunds = null,
    Object? paymentsByMethod = null,
    Object? averagePayment = null,
  }) {
    return _then(
      _value.copyWith(
            totalPayments: null == totalPayments
                ? _value.totalPayments
                : totalPayments // ignore: cast_nullable_to_non_nullable
                      as double,
            totalRefunds: null == totalRefunds
                ? _value.totalRefunds
                : totalRefunds // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentsByMethod: null == paymentsByMethod
                ? _value.paymentsByMethod
                : paymentsByMethod // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            averagePayment: null == averagePayment
                ? _value.averagePayment
                : averagePayment // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentSummaryImplCopyWith<$Res>
    implements $PaymentSummaryCopyWith<$Res> {
  factory _$$PaymentSummaryImplCopyWith(
    _$PaymentSummaryImpl value,
    $Res Function(_$PaymentSummaryImpl) then,
  ) = __$$PaymentSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalPayments,
    double totalRefunds,
    Map<String, double> paymentsByMethod,
    double averagePayment,
  });
}

/// @nodoc
class __$$PaymentSummaryImplCopyWithImpl<$Res>
    extends _$PaymentSummaryCopyWithImpl<$Res, _$PaymentSummaryImpl>
    implements _$$PaymentSummaryImplCopyWith<$Res> {
  __$$PaymentSummaryImplCopyWithImpl(
    _$PaymentSummaryImpl _value,
    $Res Function(_$PaymentSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPayments = null,
    Object? totalRefunds = null,
    Object? paymentsByMethod = null,
    Object? averagePayment = null,
  }) {
    return _then(
      _$PaymentSummaryImpl(
        totalPayments: null == totalPayments
            ? _value.totalPayments
            : totalPayments // ignore: cast_nullable_to_non_nullable
                  as double,
        totalRefunds: null == totalRefunds
            ? _value.totalRefunds
            : totalRefunds // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentsByMethod: null == paymentsByMethod
            ? _value._paymentsByMethod
            : paymentsByMethod // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        averagePayment: null == averagePayment
            ? _value.averagePayment
            : averagePayment // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentSummaryImpl implements _PaymentSummary {
  const _$PaymentSummaryImpl({
    required this.totalPayments,
    required this.totalRefunds,
    required final Map<String, double> paymentsByMethod,
    required this.averagePayment,
  }) : _paymentsByMethod = paymentsByMethod;

  factory _$PaymentSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentSummaryImplFromJson(json);

  @override
  final double totalPayments;
  @override
  final double totalRefunds;
  final Map<String, double> _paymentsByMethod;
  @override
  Map<String, double> get paymentsByMethod {
    if (_paymentsByMethod is EqualUnmodifiableMapView) return _paymentsByMethod;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_paymentsByMethod);
  }

  @override
  final double averagePayment;

  @override
  String toString() {
    return 'PaymentSummary(totalPayments: $totalPayments, totalRefunds: $totalRefunds, paymentsByMethod: $paymentsByMethod, averagePayment: $averagePayment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSummaryImpl &&
            (identical(other.totalPayments, totalPayments) ||
                other.totalPayments == totalPayments) &&
            (identical(other.totalRefunds, totalRefunds) ||
                other.totalRefunds == totalRefunds) &&
            const DeepCollectionEquality().equals(
              other._paymentsByMethod,
              _paymentsByMethod,
            ) &&
            (identical(other.averagePayment, averagePayment) ||
                other.averagePayment == averagePayment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalPayments,
    totalRefunds,
    const DeepCollectionEquality().hash(_paymentsByMethod),
    averagePayment,
  );

  /// Create a copy of PaymentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSummaryImplCopyWith<_$PaymentSummaryImpl> get copyWith =>
      __$$PaymentSummaryImplCopyWithImpl<_$PaymentSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentSummaryImplToJson(this);
  }
}

abstract class _PaymentSummary implements PaymentSummary {
  const factory _PaymentSummary({
    required final double totalPayments,
    required final double totalRefunds,
    required final Map<String, double> paymentsByMethod,
    required final double averagePayment,
  }) = _$PaymentSummaryImpl;

  factory _PaymentSummary.fromJson(Map<String, dynamic> json) =
      _$PaymentSummaryImpl.fromJson;

  @override
  double get totalPayments;
  @override
  double get totalRefunds;
  @override
  Map<String, double> get paymentsByMethod;
  @override
  double get averagePayment;

  /// Create a copy of PaymentSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentSummaryImplCopyWith<_$PaymentSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
