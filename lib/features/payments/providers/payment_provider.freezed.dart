// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PaymentState {
  Order get orderToProcess =>
      throw _privateConstructorUsedError; // Ödenecek sipariş
  double get amountReceived =>
      throw _privateConstructorUsedError; // Müşteriden alınan tutar
  double get changeDue => throw _privateConstructorUsedError; // Para üstü
  double get discountApplied =>
      throw _privateConstructorUsedError; // Uygulanan indirim tutarı
  String get discountCode => throw _privateConstructorUsedError; // İndirim kodu
  PaymentMethod get selectedPaymentMethod =>
      throw _privateConstructorUsedError; // Seçilen ödeme yöntemi
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get printingError => throw _privateConstructorUsedError;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentStateCopyWith<PaymentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentStateCopyWith<$Res> {
  factory $PaymentStateCopyWith(
    PaymentState value,
    $Res Function(PaymentState) then,
  ) = _$PaymentStateCopyWithImpl<$Res, PaymentState>;
  @useResult
  $Res call({
    Order orderToProcess,
    double amountReceived,
    double changeDue,
    double discountApplied,
    String discountCode,
    PaymentMethod selectedPaymentMethod,
    bool isLoading,
    String? errorMessage,
    bool printingError,
  });

  $OrderCopyWith<$Res> get orderToProcess;
}

/// @nodoc
class _$PaymentStateCopyWithImpl<$Res, $Val extends PaymentState>
    implements $PaymentStateCopyWith<$Res> {
  _$PaymentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderToProcess = null,
    Object? amountReceived = null,
    Object? changeDue = null,
    Object? discountApplied = null,
    Object? discountCode = null,
    Object? selectedPaymentMethod = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? printingError = null,
  }) {
    return _then(
      _value.copyWith(
            orderToProcess: null == orderToProcess
                ? _value.orderToProcess
                : orderToProcess // ignore: cast_nullable_to_non_nullable
                      as Order,
            amountReceived: null == amountReceived
                ? _value.amountReceived
                : amountReceived // ignore: cast_nullable_to_non_nullable
                      as double,
            changeDue: null == changeDue
                ? _value.changeDue
                : changeDue // ignore: cast_nullable_to_non_nullable
                      as double,
            discountApplied: null == discountApplied
                ? _value.discountApplied
                : discountApplied // ignore: cast_nullable_to_non_nullable
                      as double,
            discountCode: null == discountCode
                ? _value.discountCode
                : discountCode // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedPaymentMethod: null == selectedPaymentMethod
                ? _value.selectedPaymentMethod
                : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            printingError: null == printingError
                ? _value.printingError
                : printingError // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCopyWith<$Res> get orderToProcess {
    return $OrderCopyWith<$Res>(_value.orderToProcess, (value) {
      return _then(_value.copyWith(orderToProcess: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentStateImplCopyWith<$Res>
    implements $PaymentStateCopyWith<$Res> {
  factory _$$PaymentStateImplCopyWith(
    _$PaymentStateImpl value,
    $Res Function(_$PaymentStateImpl) then,
  ) = __$$PaymentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Order orderToProcess,
    double amountReceived,
    double changeDue,
    double discountApplied,
    String discountCode,
    PaymentMethod selectedPaymentMethod,
    bool isLoading,
    String? errorMessage,
    bool printingError,
  });

  @override
  $OrderCopyWith<$Res> get orderToProcess;
}

/// @nodoc
class __$$PaymentStateImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentStateImpl>
    implements _$$PaymentStateImplCopyWith<$Res> {
  __$$PaymentStateImplCopyWithImpl(
    _$PaymentStateImpl _value,
    $Res Function(_$PaymentStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderToProcess = null,
    Object? amountReceived = null,
    Object? changeDue = null,
    Object? discountApplied = null,
    Object? discountCode = null,
    Object? selectedPaymentMethod = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? printingError = null,
  }) {
    return _then(
      _$PaymentStateImpl(
        orderToProcess: null == orderToProcess
            ? _value.orderToProcess
            : orderToProcess // ignore: cast_nullable_to_non_nullable
                  as Order,
        amountReceived: null == amountReceived
            ? _value.amountReceived
            : amountReceived // ignore: cast_nullable_to_non_nullable
                  as double,
        changeDue: null == changeDue
            ? _value.changeDue
            : changeDue // ignore: cast_nullable_to_non_nullable
                  as double,
        discountApplied: null == discountApplied
            ? _value.discountApplied
            : discountApplied // ignore: cast_nullable_to_non_nullable
                  as double,
        discountCode: null == discountCode
            ? _value.discountCode
            : discountCode // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedPaymentMethod: null == selectedPaymentMethod
            ? _value.selectedPaymentMethod
            : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        printingError: null == printingError
            ? _value.printingError
            : printingError // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PaymentStateImpl extends _PaymentState {
  const _$PaymentStateImpl({
    required this.orderToProcess,
    this.amountReceived = 0.0,
    this.changeDue = 0.0,
    this.discountApplied = 0.0,
    this.discountCode = '',
    this.selectedPaymentMethod = PaymentMethod.cash,
    this.isLoading = false,
    this.errorMessage,
    this.printingError = false,
  }) : super._();

  @override
  final Order orderToProcess;
  // Ödenecek sipariş
  @override
  @JsonKey()
  final double amountReceived;
  // Müşteriden alınan tutar
  @override
  @JsonKey()
  final double changeDue;
  // Para üstü
  @override
  @JsonKey()
  final double discountApplied;
  // Uygulanan indirim tutarı
  @override
  @JsonKey()
  final String discountCode;
  // İndirim kodu
  @override
  @JsonKey()
  final PaymentMethod selectedPaymentMethod;
  // Seçilen ödeme yöntemi
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool printingError;

  @override
  String toString() {
    return 'PaymentState(orderToProcess: $orderToProcess, amountReceived: $amountReceived, changeDue: $changeDue, discountApplied: $discountApplied, discountCode: $discountCode, selectedPaymentMethod: $selectedPaymentMethod, isLoading: $isLoading, errorMessage: $errorMessage, printingError: $printingError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentStateImpl &&
            (identical(other.orderToProcess, orderToProcess) ||
                other.orderToProcess == orderToProcess) &&
            (identical(other.amountReceived, amountReceived) ||
                other.amountReceived == amountReceived) &&
            (identical(other.changeDue, changeDue) ||
                other.changeDue == changeDue) &&
            (identical(other.discountApplied, discountApplied) ||
                other.discountApplied == discountApplied) &&
            (identical(other.discountCode, discountCode) ||
                other.discountCode == discountCode) &&
            (identical(other.selectedPaymentMethod, selectedPaymentMethod) ||
                other.selectedPaymentMethod == selectedPaymentMethod) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.printingError, printingError) ||
                other.printingError == printingError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderToProcess,
    amountReceived,
    changeDue,
    discountApplied,
    discountCode,
    selectedPaymentMethod,
    isLoading,
    errorMessage,
    printingError,
  );

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentStateImplCopyWith<_$PaymentStateImpl> get copyWith =>
      __$$PaymentStateImplCopyWithImpl<_$PaymentStateImpl>(this, _$identity);
}

abstract class _PaymentState extends PaymentState {
  const factory _PaymentState({
    required final Order orderToProcess,
    final double amountReceived,
    final double changeDue,
    final double discountApplied,
    final String discountCode,
    final PaymentMethod selectedPaymentMethod,
    final bool isLoading,
    final String? errorMessage,
    final bool printingError,
  }) = _$PaymentStateImpl;
  const _PaymentState._() : super._();

  @override
  Order get orderToProcess; // Ödenecek sipariş
  @override
  double get amountReceived; // Müşteriden alınan tutar
  @override
  double get changeDue; // Para üstü
  @override
  double get discountApplied; // Uygulanan indirim tutarı
  @override
  String get discountCode; // İndirim kodu
  @override
  PaymentMethod get selectedPaymentMethod; // Seçilen ödeme yöntemi
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  bool get printingError;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentStateImplCopyWith<_$PaymentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
