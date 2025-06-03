// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'online_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OnlineOrder _$OnlineOrderFromJson(Map<String, dynamic> json) {
  return _OnlineOrder.fromJson(json);
}

/// @nodoc
mixin _$OnlineOrder {
  String get onlineOrderId =>
      throw _privateConstructorUsedError; // Platform's own order ID
  OnlinePlatform get platform =>
      throw _privateConstructorUsedError; // Platform from which the order came
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError; // Optional
  String? get customerAddress =>
      throw _privateConstructorUsedError; // Optional, delivery address
  List<OrderItem> get items =>
      throw _privateConstructorUsedError; // Products in POS OrderItem format
  double get totalAmount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get customerNote =>
      throw _privateConstructorUsedError; // Note from customer
  bool get isAccepted =>
      throw _privateConstructorUsedError; // Has it been accepted by POS?
  bool get isRejected =>
      throw _privateConstructorUsedError; // Has it been rejected by POS?
  String? get rejectionReason => throw _privateConstructorUsedError;

  /// Serializes this OnlineOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnlineOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnlineOrderCopyWith<OnlineOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnlineOrderCopyWith<$Res> {
  factory $OnlineOrderCopyWith(
    OnlineOrder value,
    $Res Function(OnlineOrder) then,
  ) = _$OnlineOrderCopyWithImpl<$Res, OnlineOrder>;
  @useResult
  $Res call({
    String onlineOrderId,
    OnlinePlatform platform,
    String customerName,
    String customerPhone,
    String? customerAddress,
    List<OrderItem> items,
    double totalAmount,
    DateTime createdAt,
    String? customerNote,
    bool isAccepted,
    bool isRejected,
    String? rejectionReason,
  });
}

/// @nodoc
class _$OnlineOrderCopyWithImpl<$Res, $Val extends OnlineOrder>
    implements $OnlineOrderCopyWith<$Res> {
  _$OnlineOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnlineOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onlineOrderId = null,
    Object? platform = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? customerAddress = freezed,
    Object? items = null,
    Object? totalAmount = null,
    Object? createdAt = null,
    Object? customerNote = freezed,
    Object? isAccepted = null,
    Object? isRejected = null,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            onlineOrderId: null == onlineOrderId
                ? _value.onlineOrderId
                : onlineOrderId // ignore: cast_nullable_to_non_nullable
                      as String,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as OnlinePlatform,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            customerPhone: null == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            customerAddress: freezed == customerAddress
                ? _value.customerAddress
                : customerAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            customerNote: freezed == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAccepted: null == isAccepted
                ? _value.isAccepted
                : isAccepted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRejected: null == isRejected
                ? _value.isRejected
                : isRejected // ignore: cast_nullable_to_non_nullable
                      as bool,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OnlineOrderImplCopyWith<$Res>
    implements $OnlineOrderCopyWith<$Res> {
  factory _$$OnlineOrderImplCopyWith(
    _$OnlineOrderImpl value,
    $Res Function(_$OnlineOrderImpl) then,
  ) = __$$OnlineOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String onlineOrderId,
    OnlinePlatform platform,
    String customerName,
    String customerPhone,
    String? customerAddress,
    List<OrderItem> items,
    double totalAmount,
    DateTime createdAt,
    String? customerNote,
    bool isAccepted,
    bool isRejected,
    String? rejectionReason,
  });
}

/// @nodoc
class __$$OnlineOrderImplCopyWithImpl<$Res>
    extends _$OnlineOrderCopyWithImpl<$Res, _$OnlineOrderImpl>
    implements _$$OnlineOrderImplCopyWith<$Res> {
  __$$OnlineOrderImplCopyWithImpl(
    _$OnlineOrderImpl _value,
    $Res Function(_$OnlineOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnlineOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onlineOrderId = null,
    Object? platform = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? customerAddress = freezed,
    Object? items = null,
    Object? totalAmount = null,
    Object? createdAt = null,
    Object? customerNote = freezed,
    Object? isAccepted = null,
    Object? isRejected = null,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _$OnlineOrderImpl(
        onlineOrderId: null == onlineOrderId
            ? _value.onlineOrderId
            : onlineOrderId // ignore: cast_nullable_to_non_nullable
                  as String,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as OnlinePlatform,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        customerPhone: null == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        customerAddress: freezed == customerAddress
            ? _value.customerAddress
            : customerAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        customerNote: freezed == customerNote
            ? _value.customerNote
            : customerNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAccepted: null == isAccepted
            ? _value.isAccepted
            : isAccepted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRejected: null == isRejected
            ? _value.isRejected
            : isRejected // ignore: cast_nullable_to_non_nullable
                  as bool,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OnlineOrderImpl implements _OnlineOrder {
  const _$OnlineOrderImpl({
    required this.onlineOrderId,
    required this.platform,
    required this.customerName,
    required this.customerPhone,
    this.customerAddress,
    final List<OrderItem> items = const [],
    required this.totalAmount,
    required this.createdAt,
    this.customerNote,
    this.isAccepted = false,
    this.isRejected = false,
    this.rejectionReason,
  }) : _items = items;

  factory _$OnlineOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnlineOrderImplFromJson(json);

  @override
  final String onlineOrderId;
  // Platform's own order ID
  @override
  final OnlinePlatform platform;
  // Platform from which the order came
  @override
  final String customerName;
  @override
  final String customerPhone;
  // Optional
  @override
  final String? customerAddress;
  // Optional, delivery address
  final List<OrderItem> _items;
  // Optional, delivery address
  @override
  @JsonKey()
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  // Products in POS OrderItem format
  @override
  final double totalAmount;
  @override
  final DateTime createdAt;
  @override
  final String? customerNote;
  // Note from customer
  @override
  @JsonKey()
  final bool isAccepted;
  // Has it been accepted by POS?
  @override
  @JsonKey()
  final bool isRejected;
  // Has it been rejected by POS?
  @override
  final String? rejectionReason;

  @override
  String toString() {
    return 'OnlineOrder(onlineOrderId: $onlineOrderId, platform: $platform, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, items: $items, totalAmount: $totalAmount, createdAt: $createdAt, customerNote: $customerNote, isAccepted: $isAccepted, isRejected: $isRejected, rejectionReason: $rejectionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnlineOrderImpl &&
            (identical(other.onlineOrderId, onlineOrderId) ||
                other.onlineOrderId == onlineOrderId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.isAccepted, isAccepted) ||
                other.isAccepted == isAccepted) &&
            (identical(other.isRejected, isRejected) ||
                other.isRejected == isRejected) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    onlineOrderId,
    platform,
    customerName,
    customerPhone,
    customerAddress,
    const DeepCollectionEquality().hash(_items),
    totalAmount,
    createdAt,
    customerNote,
    isAccepted,
    isRejected,
    rejectionReason,
  );

  /// Create a copy of OnlineOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnlineOrderImplCopyWith<_$OnlineOrderImpl> get copyWith =>
      __$$OnlineOrderImplCopyWithImpl<_$OnlineOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnlineOrderImplToJson(this);
  }
}

abstract class _OnlineOrder implements OnlineOrder {
  const factory _OnlineOrder({
    required final String onlineOrderId,
    required final OnlinePlatform platform,
    required final String customerName,
    required final String customerPhone,
    final String? customerAddress,
    final List<OrderItem> items,
    required final double totalAmount,
    required final DateTime createdAt,
    final String? customerNote,
    final bool isAccepted,
    final bool isRejected,
    final String? rejectionReason,
  }) = _$OnlineOrderImpl;

  factory _OnlineOrder.fromJson(Map<String, dynamic> json) =
      _$OnlineOrderImpl.fromJson;

  @override
  String get onlineOrderId; // Platform's own order ID
  @override
  OnlinePlatform get platform; // Platform from which the order came
  @override
  String get customerName;
  @override
  String get customerPhone; // Optional
  @override
  String? get customerAddress; // Optional, delivery address
  @override
  List<OrderItem> get items; // Products in POS OrderItem format
  @override
  double get totalAmount;
  @override
  DateTime get createdAt;
  @override
  String? get customerNote; // Note from customer
  @override
  bool get isAccepted; // Has it been accepted by POS?
  @override
  bool get isRejected; // Has it been rejected by POS?
  @override
  String? get rejectionReason;

  /// Create a copy of OnlineOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnlineOrderImplCopyWith<_$OnlineOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
