// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  String? get tableId => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String? get tableNumber => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
  OrderStatus get status => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get customerNote => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _paymentMethodFromJson, toJson: _paymentMethodToJson)
  PaymentMethod? get paymentMethod => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_order_id')
  String? get currentOrderId => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    String id,
    String? tableId,
    String? userId,
    String orderNumber,
    String? tableNumber,
    List<OrderItem> items,
    @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
    OrderStatus status,
    double totalAmount,
    DateTime createdAt,
    DateTime? updatedAt,
    String? customerNote,
    double? discountAmount,
    @JsonKey(fromJson: _paymentMethodFromJson, toJson: _paymentMethodToJson)
    PaymentMethod? paymentMethod,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'current_order_id') String? currentOrderId,
  });
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableId = freezed,
    Object? userId = freezed,
    Object? orderNumber = null,
    Object? tableNumber = freezed,
    Object? items = null,
    Object? status = null,
    Object? totalAmount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? customerNote = freezed,
    Object? discountAmount = freezed,
    Object? paymentMethod = freezed,
    Object? metadata = freezed,
    Object? currentOrderId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tableId: freezed == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            tableNumber: freezed == tableNumber
                ? _value.tableNumber
                : tableNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            customerNote: freezed == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountAmount: freezed == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            currentOrderId: freezed == currentOrderId
                ? _value.currentOrderId
                : currentOrderId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? tableId,
    String? userId,
    String orderNumber,
    String? tableNumber,
    List<OrderItem> items,
    @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
    OrderStatus status,
    double totalAmount,
    DateTime createdAt,
    DateTime? updatedAt,
    String? customerNote,
    double? discountAmount,
    @JsonKey(fromJson: _paymentMethodFromJson, toJson: _paymentMethodToJson)
    PaymentMethod? paymentMethod,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'current_order_id') String? currentOrderId,
  });
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableId = freezed,
    Object? userId = freezed,
    Object? orderNumber = null,
    Object? tableNumber = freezed,
    Object? items = null,
    Object? status = null,
    Object? totalAmount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? customerNote = freezed,
    Object? discountAmount = freezed,
    Object? paymentMethod = freezed,
    Object? metadata = freezed,
    Object? currentOrderId = freezed,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tableId: freezed == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        tableNumber: freezed == tableNumber
            ? _value.tableNumber
            : tableNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        customerNote: freezed == customerNote
            ? _value.customerNote
            : customerNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountAmount: freezed == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        currentOrderId: freezed == currentOrderId
            ? _value.currentOrderId
            : currentOrderId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl extends _Order {
  const _$OrderImpl({
    required this.id,
    this.tableId,
    this.userId,
    required this.orderNumber,
    this.tableNumber,
    required final List<OrderItem> items,
    @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.updatedAt,
    this.customerNote,
    this.discountAmount,
    @JsonKey(fromJson: _paymentMethodFromJson, toJson: _paymentMethodToJson)
    this.paymentMethod,
    final Map<String, dynamic>? metadata,
    @JsonKey(name: 'current_order_id') this.currentOrderId,
  }) : _items = items,
       _metadata = metadata,
       super._();

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  final String? tableId;
  @override
  final String? userId;
  @override
  final String orderNumber;
  @override
  final String? tableNumber;
  final List<OrderItem> _items;
  @override
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
  final OrderStatus status;
  @override
  final double totalAmount;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? customerNote;
  @override
  final double? discountAmount;
  @override
  @JsonKey(fromJson: _paymentMethodFromJson, toJson: _paymentMethodToJson)
  final PaymentMethod? paymentMethod;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'current_order_id')
  final String? currentOrderId;

  @override
  String toString() {
    return 'Order(id: $id, tableId: $tableId, userId: $userId, orderNumber: $orderNumber, tableNumber: $tableNumber, items: $items, status: $status, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt, customerNote: $customerNote, discountAmount: $discountAmount, paymentMethod: $paymentMethod, metadata: $metadata, currentOrderId: $currentOrderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.currentOrderId, currentOrderId) ||
                other.currentOrderId == currentOrderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tableId,
    userId,
    orderNumber,
    tableNumber,
    const DeepCollectionEquality().hash(_items),
    status,
    totalAmount,
    createdAt,
    updatedAt,
    customerNote,
    discountAmount,
    paymentMethod,
    const DeepCollectionEquality().hash(_metadata),
    currentOrderId,
  );

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(this);
  }
}

abstract class _Order extends Order {
  const factory _Order({
    required final String id,
    final String? tableId,
    final String? userId,
    required final String orderNumber,
    final String? tableNumber,
    required final List<OrderItem> items,
    @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
    required final OrderStatus status,
    required final double totalAmount,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final String? customerNote,
    final double? discountAmount,
    @JsonKey(fromJson: _paymentMethodFromJson, toJson: _paymentMethodToJson)
    final PaymentMethod? paymentMethod,
    final Map<String, dynamic>? metadata,
    @JsonKey(name: 'current_order_id') final String? currentOrderId,
  }) = _$OrderImpl;
  const _Order._() : super._();

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  String? get tableId;
  @override
  String? get userId;
  @override
  String get orderNumber;
  @override
  String? get tableNumber;
  @override
  List<OrderItem> get items;
  @override
  @JsonKey(fromJson: _orderStatusFromJson, toJson: _orderStatusToJson)
  OrderStatus get status;
  @override
  double get totalAmount;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get customerNote;
  @override
  double? get discountAmount;
  @override
  @JsonKey(fromJson: _paymentMethodFromJson, toJson: _paymentMethodToJson)
  PaymentMethod? get paymentMethod;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'current_order_id')
  String? get currentOrderId;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
