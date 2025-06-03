// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TableReport _$TableReportFromJson(Map<String, dynamic> json) {
  return _TableReport.fromJson(json);
}

/// @nodoc
mixin _$TableReport {
  String get tableNumber => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;
  double get totalSales => throw _privateConstructorUsedError;

  /// Serializes this TableReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TableReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TableReportCopyWith<TableReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableReportCopyWith<$Res> {
  factory $TableReportCopyWith(
    TableReport value,
    $Res Function(TableReport) then,
  ) = _$TableReportCopyWithImpl<$Res, TableReport>;
  @useResult
  $Res call({String tableNumber, int orderCount, double totalSales});
}

/// @nodoc
class _$TableReportCopyWithImpl<$Res, $Val extends TableReport>
    implements $TableReportCopyWith<$Res> {
  _$TableReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TableReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableNumber = null,
    Object? orderCount = null,
    Object? totalSales = null,
  }) {
    return _then(
      _value.copyWith(
            tableNumber: null == tableNumber
                ? _value.tableNumber
                : tableNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            orderCount: null == orderCount
                ? _value.orderCount
                : orderCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSales: null == totalSales
                ? _value.totalSales
                : totalSales // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TableReportImplCopyWith<$Res>
    implements $TableReportCopyWith<$Res> {
  factory _$$TableReportImplCopyWith(
    _$TableReportImpl value,
    $Res Function(_$TableReportImpl) then,
  ) = __$$TableReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tableNumber, int orderCount, double totalSales});
}

/// @nodoc
class __$$TableReportImplCopyWithImpl<$Res>
    extends _$TableReportCopyWithImpl<$Res, _$TableReportImpl>
    implements _$$TableReportImplCopyWith<$Res> {
  __$$TableReportImplCopyWithImpl(
    _$TableReportImpl _value,
    $Res Function(_$TableReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TableReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableNumber = null,
    Object? orderCount = null,
    Object? totalSales = null,
  }) {
    return _then(
      _$TableReportImpl(
        tableNumber: null == tableNumber
            ? _value.tableNumber
            : tableNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        orderCount: null == orderCount
            ? _value.orderCount
            : orderCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSales: null == totalSales
            ? _value.totalSales
            : totalSales // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TableReportImpl implements _TableReport {
  const _$TableReportImpl({
    required this.tableNumber,
    this.orderCount = 0,
    this.totalSales = 0.0,
  });

  factory _$TableReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$TableReportImplFromJson(json);

  @override
  final String tableNumber;
  @override
  @JsonKey()
  final int orderCount;
  @override
  @JsonKey()
  final double totalSales;

  @override
  String toString() {
    return 'TableReport(tableNumber: $tableNumber, orderCount: $orderCount, totalSales: $totalSales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TableReportImpl &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tableNumber, orderCount, totalSales);

  /// Create a copy of TableReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TableReportImplCopyWith<_$TableReportImpl> get copyWith =>
      __$$TableReportImplCopyWithImpl<_$TableReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TableReportImplToJson(this);
  }
}

abstract class _TableReport implements TableReport {
  const factory _TableReport({
    required final String tableNumber,
    final int orderCount,
    final double totalSales,
  }) = _$TableReportImpl;

  factory _TableReport.fromJson(Map<String, dynamic> json) =
      _$TableReportImpl.fromJson;

  @override
  String get tableNumber;
  @override
  int get orderCount;
  @override
  double get totalSales;

  /// Create a copy of TableReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TableReportImplCopyWith<_$TableReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
