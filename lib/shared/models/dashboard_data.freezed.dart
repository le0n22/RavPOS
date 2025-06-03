// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) {
  return _DashboardData.fromJson(json);
}

/// @nodoc
mixin _$DashboardData {
  double get todaySales => throw _privateConstructorUsedError;
  int get todayOrderCount => throw _privateConstructorUsedError;
  int get pendingOrdersCount => throw _privateConstructorUsedError;
  int get totalProductsCount => throw _privateConstructorUsedError;
  int get totalCategoriesCount => throw _privateConstructorUsedError;
  List<Order> get recentOrders => throw _privateConstructorUsedError;

  /// Serializes this DashboardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
    DashboardData value,
    $Res Function(DashboardData) then,
  ) = _$DashboardDataCopyWithImpl<$Res, DashboardData>;
  @useResult
  $Res call({
    double todaySales,
    int todayOrderCount,
    int pendingOrdersCount,
    int totalProductsCount,
    int totalCategoriesCount,
    List<Order> recentOrders,
  });
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res, $Val extends DashboardData>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todaySales = null,
    Object? todayOrderCount = null,
    Object? pendingOrdersCount = null,
    Object? totalProductsCount = null,
    Object? totalCategoriesCount = null,
    Object? recentOrders = null,
  }) {
    return _then(
      _value.copyWith(
            todaySales: null == todaySales
                ? _value.todaySales
                : todaySales // ignore: cast_nullable_to_non_nullable
                      as double,
            todayOrderCount: null == todayOrderCount
                ? _value.todayOrderCount
                : todayOrderCount // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingOrdersCount: null == pendingOrdersCount
                ? _value.pendingOrdersCount
                : pendingOrdersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalProductsCount: null == totalProductsCount
                ? _value.totalProductsCount
                : totalProductsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCategoriesCount: null == totalCategoriesCount
                ? _value.totalCategoriesCount
                : totalCategoriesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            recentOrders: null == recentOrders
                ? _value.recentOrders
                : recentOrders // ignore: cast_nullable_to_non_nullable
                      as List<Order>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardDataImplCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$$DashboardDataImplCopyWith(
    _$DashboardDataImpl value,
    $Res Function(_$DashboardDataImpl) then,
  ) = __$$DashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double todaySales,
    int todayOrderCount,
    int pendingOrdersCount,
    int totalProductsCount,
    int totalCategoriesCount,
    List<Order> recentOrders,
  });
}

/// @nodoc
class __$$DashboardDataImplCopyWithImpl<$Res>
    extends _$DashboardDataCopyWithImpl<$Res, _$DashboardDataImpl>
    implements _$$DashboardDataImplCopyWith<$Res> {
  __$$DashboardDataImplCopyWithImpl(
    _$DashboardDataImpl _value,
    $Res Function(_$DashboardDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todaySales = null,
    Object? todayOrderCount = null,
    Object? pendingOrdersCount = null,
    Object? totalProductsCount = null,
    Object? totalCategoriesCount = null,
    Object? recentOrders = null,
  }) {
    return _then(
      _$DashboardDataImpl(
        todaySales: null == todaySales
            ? _value.todaySales
            : todaySales // ignore: cast_nullable_to_non_nullable
                  as double,
        todayOrderCount: null == todayOrderCount
            ? _value.todayOrderCount
            : todayOrderCount // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingOrdersCount: null == pendingOrdersCount
            ? _value.pendingOrdersCount
            : pendingOrdersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalProductsCount: null == totalProductsCount
            ? _value.totalProductsCount
            : totalProductsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCategoriesCount: null == totalCategoriesCount
            ? _value.totalCategoriesCount
            : totalCategoriesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        recentOrders: null == recentOrders
            ? _value._recentOrders
            : recentOrders // ignore: cast_nullable_to_non_nullable
                  as List<Order>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardDataImpl implements _DashboardData {
  const _$DashboardDataImpl({
    this.todaySales = 0,
    this.todayOrderCount = 0,
    this.pendingOrdersCount = 0,
    this.totalProductsCount = 0,
    this.totalCategoriesCount = 0,
    final List<Order> recentOrders = const [],
  }) : _recentOrders = recentOrders;

  factory _$DashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardDataImplFromJson(json);

  @override
  @JsonKey()
  final double todaySales;
  @override
  @JsonKey()
  final int todayOrderCount;
  @override
  @JsonKey()
  final int pendingOrdersCount;
  @override
  @JsonKey()
  final int totalProductsCount;
  @override
  @JsonKey()
  final int totalCategoriesCount;
  final List<Order> _recentOrders;
  @override
  @JsonKey()
  List<Order> get recentOrders {
    if (_recentOrders is EqualUnmodifiableListView) return _recentOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentOrders);
  }

  @override
  String toString() {
    return 'DashboardData(todaySales: $todaySales, todayOrderCount: $todayOrderCount, pendingOrdersCount: $pendingOrdersCount, totalProductsCount: $totalProductsCount, totalCategoriesCount: $totalCategoriesCount, recentOrders: $recentOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardDataImpl &&
            (identical(other.todaySales, todaySales) ||
                other.todaySales == todaySales) &&
            (identical(other.todayOrderCount, todayOrderCount) ||
                other.todayOrderCount == todayOrderCount) &&
            (identical(other.pendingOrdersCount, pendingOrdersCount) ||
                other.pendingOrdersCount == pendingOrdersCount) &&
            (identical(other.totalProductsCount, totalProductsCount) ||
                other.totalProductsCount == totalProductsCount) &&
            (identical(other.totalCategoriesCount, totalCategoriesCount) ||
                other.totalCategoriesCount == totalCategoriesCount) &&
            const DeepCollectionEquality().equals(
              other._recentOrders,
              _recentOrders,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    todaySales,
    todayOrderCount,
    pendingOrdersCount,
    totalProductsCount,
    totalCategoriesCount,
    const DeepCollectionEquality().hash(_recentOrders),
  );

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      __$$DashboardDataImplCopyWithImpl<_$DashboardDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardDataImplToJson(this);
  }
}

abstract class _DashboardData implements DashboardData {
  const factory _DashboardData({
    final double todaySales,
    final int todayOrderCount,
    final int pendingOrdersCount,
    final int totalProductsCount,
    final int totalCategoriesCount,
    final List<Order> recentOrders,
  }) = _$DashboardDataImpl;

  factory _DashboardData.fromJson(Map<String, dynamic> json) =
      _$DashboardDataImpl.fromJson;

  @override
  double get todaySales;
  @override
  int get todayOrderCount;
  @override
  int get pendingOrdersCount;
  @override
  int get totalProductsCount;
  @override
  int get totalCategoriesCount;
  @override
  List<Order> get recentOrders;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
