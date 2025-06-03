// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_sales.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductSales _$ProductSalesFromJson(Map<String, dynamic> json) {
  return _ProductSales.fromJson(json);
}

/// @nodoc
mixin _$ProductSales {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get totalQuantitySold => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;

  /// Serializes this ProductSales to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSalesCopyWith<ProductSales> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSalesCopyWith<$Res> {
  factory $ProductSalesCopyWith(
    ProductSales value,
    $Res Function(ProductSales) then,
  ) = _$ProductSalesCopyWithImpl<$Res, ProductSales>;
  @useResult
  $Res call({
    String productId,
    String productName,
    int totalQuantitySold,
    double totalRevenue,
  });
}

/// @nodoc
class _$ProductSalesCopyWithImpl<$Res, $Val extends ProductSales>
    implements $ProductSalesCopyWith<$Res> {
  _$ProductSalesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? totalQuantitySold = null,
    Object? totalRevenue = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalQuantitySold: null == totalQuantitySold
                ? _value.totalQuantitySold
                : totalQuantitySold // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductSalesImplCopyWith<$Res>
    implements $ProductSalesCopyWith<$Res> {
  factory _$$ProductSalesImplCopyWith(
    _$ProductSalesImpl value,
    $Res Function(_$ProductSalesImpl) then,
  ) = __$$ProductSalesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String productName,
    int totalQuantitySold,
    double totalRevenue,
  });
}

/// @nodoc
class __$$ProductSalesImplCopyWithImpl<$Res>
    extends _$ProductSalesCopyWithImpl<$Res, _$ProductSalesImpl>
    implements _$$ProductSalesImplCopyWith<$Res> {
  __$$ProductSalesImplCopyWithImpl(
    _$ProductSalesImpl _value,
    $Res Function(_$ProductSalesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? totalQuantitySold = null,
    Object? totalRevenue = null,
  }) {
    return _then(
      _$ProductSalesImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalQuantitySold: null == totalQuantitySold
            ? _value.totalQuantitySold
            : totalQuantitySold // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSalesImpl implements _ProductSales {
  const _$ProductSalesImpl({
    required this.productId,
    required this.productName,
    required this.totalQuantitySold,
    required this.totalRevenue,
  });

  factory _$ProductSalesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSalesImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int totalQuantitySold;
  @override
  final double totalRevenue;

  @override
  String toString() {
    return 'ProductSales(productId: $productId, productName: $productName, totalQuantitySold: $totalQuantitySold, totalRevenue: $totalRevenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSalesImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.totalQuantitySold, totalQuantitySold) ||
                other.totalQuantitySold == totalQuantitySold) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    productName,
    totalQuantitySold,
    totalRevenue,
  );

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSalesImplCopyWith<_$ProductSalesImpl> get copyWith =>
      __$$ProductSalesImplCopyWithImpl<_$ProductSalesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSalesImplToJson(this);
  }
}

abstract class _ProductSales implements ProductSales {
  const factory _ProductSales({
    required final String productId,
    required final String productName,
    required final int totalQuantitySold,
    required final double totalRevenue,
  }) = _$ProductSalesImpl;

  factory _ProductSales.fromJson(Map<String, dynamic> json) =
      _$ProductSalesImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get totalQuantitySold;
  @override
  double get totalRevenue;

  /// Create a copy of ProductSales
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSalesImplCopyWith<_$ProductSalesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
