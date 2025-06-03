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
  @JsonKey(readValue: _idAsString)
  String get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'total', fromJson: _doubleFromJson, toJson: _doubleToJson)
  double get totalAmount => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  String? get tableId => throw _privateConstructorUsedError;
  String? get tableNumber => throw _privateConstructorUsedError;
  @JsonKey(
    name: 'items',
    defaultValue: <OrderItem>[],
    fromJson: _itemsFromJson,
    toJson: _itemsToJson,
  )
  List<OrderItem> get items => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  String? get customerNote => throw _privateConstructorUsedError;
  PaymentMethod? get paymentMethod => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  String? get currentOrderId => throw _privateConstructorUsedError;
  bool get isNew => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_id')
  String? get requestId => throw _privateConstructorUsedError;

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
    @JsonKey(readValue: _idAsString) String id,
    String orderNumber,
    @JsonKey(name: 'total', fromJson: _doubleFromJson, toJson: _doubleToJson)
    double totalAmount,
    OrderStatus status,
    String? tableId,
    String? tableNumber,
    @JsonKey(
      name: 'items',
      defaultValue: <OrderItem>[],
      fromJson: _itemsFromJson,
      toJson: _itemsToJson,
    )
    List<OrderItem> items,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? discountAmount,
    String? customerNote,
    PaymentMethod? paymentMethod,
    Map<String, dynamic>? metadata,
    String? currentOrderId,
    bool isNew,
    @JsonKey(name: 'request_id') String? requestId,
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
    Object? orderNumber = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? tableId = freezed,
    Object? tableNumber = freezed,
    Object? items = null,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? discountAmount = freezed,
    Object? customerNote = freezed,
    Object? paymentMethod = freezed,
    Object? metadata = freezed,
    Object? currentOrderId = freezed,
    Object? isNew = null,
    Object? requestId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            tableId: freezed == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String?,
            tableNumber: freezed == tableNumber
                ? _value.tableNumber
                : tableNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            discountAmount: freezed == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            customerNote: freezed == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            isNew: null == isNew
                ? _value.isNew
                : isNew // ignore: cast_nullable_to_non_nullable
                      as bool,
            requestId: freezed == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(readValue: _idAsString) String id,
    String orderNumber,
    @JsonKey(name: 'total', fromJson: _doubleFromJson, toJson: _doubleToJson)
    double totalAmount,
    OrderStatus status,
    String? tableId,
    String? tableNumber,
    @JsonKey(
      name: 'items',
      defaultValue: <OrderItem>[],
      fromJson: _itemsFromJson,
      toJson: _itemsToJson,
    )
    List<OrderItem> items,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? discountAmount,
    String? customerNote,
    PaymentMethod? paymentMethod,
    Map<String, dynamic>? metadata,
    String? currentOrderId,
    bool isNew,
    @JsonKey(name: 'request_id') String? requestId,
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
    Object? orderNumber = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? tableId = freezed,
    Object? tableNumber = freezed,
    Object? items = null,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? discountAmount = freezed,
    Object? customerNote = freezed,
    Object? paymentMethod = freezed,
    Object? metadata = freezed,
    Object? currentOrderId = freezed,
    Object? isNew = null,
    Object? requestId = freezed,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        tableId: freezed == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tableNumber: freezed == tableNumber
            ? _value.tableNumber
            : tableNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        discountAmount: freezed == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        customerNote: freezed == customerNote
            ? _value.customerNote
            : customerNote // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        isNew: null == isNew
            ? _value.isNew
            : isNew // ignore: cast_nullable_to_non_nullable
                  as bool,
        requestId: freezed == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$OrderImpl extends _Order {
  const _$OrderImpl({
    @JsonKey(readValue: _idAsString) required this.id,
    required this.orderNumber,
    @JsonKey(name: 'total', fromJson: _doubleFromJson, toJson: _doubleToJson)
    required this.totalAmount,
    required this.status,
    this.tableId,
    this.tableNumber,
    @JsonKey(
      name: 'items',
      defaultValue: <OrderItem>[],
      fromJson: _itemsFromJson,
      toJson: _itemsToJson,
    )
    required final List<OrderItem> items,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.discountAmount,
    this.customerNote,
    this.paymentMethod,
    final Map<String, dynamic>? metadata,
    this.currentOrderId,
    this.isNew = false,
    @JsonKey(name: 'request_id') this.requestId,
  }) : _items = items,
       _metadata = metadata,
       super._();

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  @JsonKey(readValue: _idAsString)
  final String id;
  @override
  final String orderNumber;
  @override
  @JsonKey(name: 'total', fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double totalAmount;
  @override
  final OrderStatus status;
  @override
  final String? tableId;
  @override
  final String? tableNumber;
  final List<OrderItem> _items;
  @override
  @JsonKey(
    name: 'items',
    defaultValue: <OrderItem>[],
    fromJson: _itemsFromJson,
    toJson: _itemsToJson,
  )
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? userId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final double? discountAmount;
  @override
  final String? customerNote;
  @override
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
  final String? currentOrderId;
  @override
  @JsonKey()
  final bool isNew;
  @override
  @JsonKey(name: 'request_id')
  final String? requestId;

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, totalAmount: $totalAmount, status: $status, tableId: $tableId, tableNumber: $tableNumber, items: $items, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, discountAmount: $discountAmount, customerNote: $customerNote, paymentMethod: $paymentMethod, metadata: $metadata, currentOrderId: $currentOrderId, isNew: $isNew, requestId: $requestId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.currentOrderId, currentOrderId) ||
                other.currentOrderId == currentOrderId) &&
            (identical(other.isNew, isNew) || other.isNew == isNew) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderNumber,
    totalAmount,
    status,
    tableId,
    tableNumber,
    const DeepCollectionEquality().hash(_items),
    userId,
    createdAt,
    updatedAt,
    discountAmount,
    customerNote,
    paymentMethod,
    const DeepCollectionEquality().hash(_metadata),
    currentOrderId,
    isNew,
    requestId,
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
    @JsonKey(readValue: _idAsString) required final String id,
    required final String orderNumber,
    @JsonKey(name: 'total', fromJson: _doubleFromJson, toJson: _doubleToJson)
    required final double totalAmount,
    required final OrderStatus status,
    final String? tableId,
    final String? tableNumber,
    @JsonKey(
      name: 'items',
      defaultValue: <OrderItem>[],
      fromJson: _itemsFromJson,
      toJson: _itemsToJson,
    )
    required final List<OrderItem> items,
    final String? userId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final double? discountAmount,
    final String? customerNote,
    final PaymentMethod? paymentMethod,
    final Map<String, dynamic>? metadata,
    final String? currentOrderId,
    final bool isNew,
    @JsonKey(name: 'request_id') final String? requestId,
  }) = _$OrderImpl;
  const _Order._() : super._();

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  @JsonKey(readValue: _idAsString)
  String get id;
  @override
  String get orderNumber;
  @override
  @JsonKey(name: 'total', fromJson: _doubleFromJson, toJson: _doubleToJson)
  double get totalAmount;
  @override
  OrderStatus get status;
  @override
  String? get tableId;
  @override
  String? get tableNumber;
  @override
  @JsonKey(
    name: 'items',
    defaultValue: <OrderItem>[],
    fromJson: _itemsFromJson,
    toJson: _itemsToJson,
  )
  List<OrderItem> get items;
  @override
  String? get userId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  double? get discountAmount;
  @override
  String? get customerNote;
  @override
  PaymentMethod? get paymentMethod;
  @override
  Map<String, dynamic>? get metadata;
  @override
  String? get currentOrderId;
  @override
  bool get isNew;
  @override
  @JsonKey(name: 'request_id')
  String? get requestId;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
