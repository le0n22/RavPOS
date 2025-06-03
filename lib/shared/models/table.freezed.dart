// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RestaurantTable _$RestaurantTableFromJson(Map<String, dynamic> json) {
  return _RestaurantTable.fromJson(json);
}

/// @nodoc
mixin _$RestaurantTable {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get capacity =>
      throw _privateConstructorUsedError; // Masa kapasitesi (kaç kişilik)
  TableStatus get status => throw _privateConstructorUsedError;
  double get xPosition =>
      throw _privateConstructorUsedError; // Görsel yerleşim için
  double get yPosition =>
      throw _privateConstructorUsedError; // Görsel yerleşim için
  String? get currentOrderId =>
      throw _privateConstructorUsedError; // Masada aktif olan siparişin ID'si
  double get currentOrderTotal =>
      throw _privateConstructorUsedError; // Aktif siparişin toplam tutarı
  DateTime? get lastOccupiedTime =>
      throw _privateConstructorUsedError; // En son ne zaman meşgul olduğu
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  /// Serializes this RestaurantTable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantTableCopyWith<RestaurantTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantTableCopyWith<$Res> {
  factory $RestaurantTableCopyWith(
    RestaurantTable value,
    $Res Function(RestaurantTable) then,
  ) = _$RestaurantTableCopyWithImpl<$Res, RestaurantTable>;
  @useResult
  $Res call({
    String id,
    String name,
    int capacity,
    TableStatus status,
    double xPosition,
    double yPosition,
    String? currentOrderId,
    double currentOrderTotal,
    DateTime? lastOccupiedTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    String category,
  });
}

/// @nodoc
class _$RestaurantTableCopyWithImpl<$Res, $Val extends RestaurantTable>
    implements $RestaurantTableCopyWith<$Res> {
  _$RestaurantTableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? capacity = null,
    Object? status = null,
    Object? xPosition = null,
    Object? yPosition = null,
    Object? currentOrderId = freezed,
    Object? currentOrderTotal = null,
    Object? lastOccupiedTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? category = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TableStatus,
            xPosition: null == xPosition
                ? _value.xPosition
                : xPosition // ignore: cast_nullable_to_non_nullable
                      as double,
            yPosition: null == yPosition
                ? _value.yPosition
                : yPosition // ignore: cast_nullable_to_non_nullable
                      as double,
            currentOrderId: freezed == currentOrderId
                ? _value.currentOrderId
                : currentOrderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentOrderTotal: null == currentOrderTotal
                ? _value.currentOrderTotal
                : currentOrderTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            lastOccupiedTime: freezed == lastOccupiedTime
                ? _value.lastOccupiedTime
                : lastOccupiedTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RestaurantTableImplCopyWith<$Res>
    implements $RestaurantTableCopyWith<$Res> {
  factory _$$RestaurantTableImplCopyWith(
    _$RestaurantTableImpl value,
    $Res Function(_$RestaurantTableImpl) then,
  ) = __$$RestaurantTableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int capacity,
    TableStatus status,
    double xPosition,
    double yPosition,
    String? currentOrderId,
    double currentOrderTotal,
    DateTime? lastOccupiedTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    String category,
  });
}

/// @nodoc
class __$$RestaurantTableImplCopyWithImpl<$Res>
    extends _$RestaurantTableCopyWithImpl<$Res, _$RestaurantTableImpl>
    implements _$$RestaurantTableImplCopyWith<$Res> {
  __$$RestaurantTableImplCopyWithImpl(
    _$RestaurantTableImpl _value,
    $Res Function(_$RestaurantTableImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? capacity = null,
    Object? status = null,
    Object? xPosition = null,
    Object? yPosition = null,
    Object? currentOrderId = freezed,
    Object? currentOrderTotal = null,
    Object? lastOccupiedTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? category = null,
  }) {
    return _then(
      _$RestaurantTableImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TableStatus,
        xPosition: null == xPosition
            ? _value.xPosition
            : xPosition // ignore: cast_nullable_to_non_nullable
                  as double,
        yPosition: null == yPosition
            ? _value.yPosition
            : yPosition // ignore: cast_nullable_to_non_nullable
                  as double,
        currentOrderId: freezed == currentOrderId
            ? _value.currentOrderId
            : currentOrderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentOrderTotal: null == currentOrderTotal
            ? _value.currentOrderTotal
            : currentOrderTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        lastOccupiedTime: freezed == lastOccupiedTime
            ? _value.lastOccupiedTime
            : lastOccupiedTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantTableImpl implements _RestaurantTable {
  const _$RestaurantTableImpl({
    required this.id,
    required this.name,
    this.capacity = 4,
    this.status = TableStatus.available,
    this.xPosition = 0.0,
    this.yPosition = 0.0,
    this.currentOrderId,
    this.currentOrderTotal = 0.0,
    this.lastOccupiedTime,
    required this.createdAt,
    this.updatedAt,
    this.category = '',
  });

  factory _$RestaurantTableImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantTableImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final int capacity;
  // Masa kapasitesi (kaç kişilik)
  @override
  @JsonKey()
  final TableStatus status;
  @override
  @JsonKey()
  final double xPosition;
  // Görsel yerleşim için
  @override
  @JsonKey()
  final double yPosition;
  // Görsel yerleşim için
  @override
  final String? currentOrderId;
  // Masada aktif olan siparişin ID'si
  @override
  @JsonKey()
  final double currentOrderTotal;
  // Aktif siparişin toplam tutarı
  @override
  final DateTime? lastOccupiedTime;
  // En son ne zaman meşgul olduğu
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final String category;

  @override
  String toString() {
    return 'RestaurantTable(id: $id, name: $name, capacity: $capacity, status: $status, xPosition: $xPosition, yPosition: $yPosition, currentOrderId: $currentOrderId, currentOrderTotal: $currentOrderTotal, lastOccupiedTime: $lastOccupiedTime, createdAt: $createdAt, updatedAt: $updatedAt, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantTableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.xPosition, xPosition) ||
                other.xPosition == xPosition) &&
            (identical(other.yPosition, yPosition) ||
                other.yPosition == yPosition) &&
            (identical(other.currentOrderId, currentOrderId) ||
                other.currentOrderId == currentOrderId) &&
            (identical(other.currentOrderTotal, currentOrderTotal) ||
                other.currentOrderTotal == currentOrderTotal) &&
            (identical(other.lastOccupiedTime, lastOccupiedTime) ||
                other.lastOccupiedTime == lastOccupiedTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    capacity,
    status,
    xPosition,
    yPosition,
    currentOrderId,
    currentOrderTotal,
    lastOccupiedTime,
    createdAt,
    updatedAt,
    category,
  );

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantTableImplCopyWith<_$RestaurantTableImpl> get copyWith =>
      __$$RestaurantTableImplCopyWithImpl<_$RestaurantTableImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantTableImplToJson(this);
  }
}

abstract class _RestaurantTable implements RestaurantTable {
  const factory _RestaurantTable({
    required final String id,
    required final String name,
    final int capacity,
    final TableStatus status,
    final double xPosition,
    final double yPosition,
    final String? currentOrderId,
    final double currentOrderTotal,
    final DateTime? lastOccupiedTime,
    required final DateTime? createdAt,
    final DateTime? updatedAt,
    final String category,
  }) = _$RestaurantTableImpl;

  factory _RestaurantTable.fromJson(Map<String, dynamic> json) =
      _$RestaurantTableImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get capacity; // Masa kapasitesi (kaç kişilik)
  @override
  TableStatus get status;
  @override
  double get xPosition; // Görsel yerleşim için
  @override
  double get yPosition; // Görsel yerleşim için
  @override
  String? get currentOrderId; // Masada aktif olan siparişin ID'si
  @override
  double get currentOrderTotal; // Aktif siparişin toplam tutarı
  @override
  DateTime? get lastOccupiedTime; // En son ne zaman meşgul olduğu
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String get category;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantTableImplCopyWith<_$RestaurantTableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
