// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportData _$ReportDataFromJson(Map<String, dynamic> json) {
  return _ReportData.fromJson(json);
}

/// @nodoc
mixin _$ReportData {
  double get totalSales =>
      throw _privateConstructorUsedError; // Toplam satış hacmi
  int get totalOrders =>
      throw _privateConstructorUsedError; // Toplam sipariş sayısı
  double get averageOrderValue =>
      throw _privateConstructorUsedError; // Ortalama sipariş tutarı
  double get totalDiscountGiven =>
      throw _privateConstructorUsedError; // Uygulanan toplam indirim
  Map<String, double> get salesByPaymentMethod =>
      throw _privateConstructorUsedError; // Örn: {'Nakit': 1000.0, 'Kart': 500.0}
  List<ProductSales> get topSellingProducts =>
      throw _privateConstructorUsedError; // En çok satan ürünler
  Map<DateTime, double> get dailySalesData =>
      throw _privateConstructorUsedError; // Günlük satış verileri {DateTime(yıl, ay, gün): toplamSatış}
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<Order> get orders =>
      throw _privateConstructorUsedError; // Raporlanan siparişler
  Map<int, int> get hourlyOrderCounts =>
      throw _privateConstructorUsedError; // Saatlik sipariş yoğunluğu
  Map<String, TableReport> get tableReports =>
      throw _privateConstructorUsedError;

  /// Serializes this ReportData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportDataCopyWith<ReportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDataCopyWith<$Res> {
  factory $ReportDataCopyWith(
    ReportData value,
    $Res Function(ReportData) then,
  ) = _$ReportDataCopyWithImpl<$Res, ReportData>;
  @useResult
  $Res call({
    double totalSales,
    int totalOrders,
    double averageOrderValue,
    double totalDiscountGiven,
    Map<String, double> salesByPaymentMethod,
    List<ProductSales> topSellingProducts,
    Map<DateTime, double> dailySalesData,
    bool isLoading,
    String? errorMessage,
    List<Order> orders,
    Map<int, int> hourlyOrderCounts,
    Map<String, TableReport> tableReports,
  });
}

/// @nodoc
class _$ReportDataCopyWithImpl<$Res, $Val extends ReportData>
    implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSales = null,
    Object? totalOrders = null,
    Object? averageOrderValue = null,
    Object? totalDiscountGiven = null,
    Object? salesByPaymentMethod = null,
    Object? topSellingProducts = null,
    Object? dailySalesData = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? orders = null,
    Object? hourlyOrderCounts = null,
    Object? tableReports = null,
  }) {
    return _then(
      _value.copyWith(
            totalSales: null == totalSales
                ? _value.totalSales
                : totalSales // ignore: cast_nullable_to_non_nullable
                      as double,
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            averageOrderValue: null == averageOrderValue
                ? _value.averageOrderValue
                : averageOrderValue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalDiscountGiven: null == totalDiscountGiven
                ? _value.totalDiscountGiven
                : totalDiscountGiven // ignore: cast_nullable_to_non_nullable
                      as double,
            salesByPaymentMethod: null == salesByPaymentMethod
                ? _value.salesByPaymentMethod
                : salesByPaymentMethod // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            topSellingProducts: null == topSellingProducts
                ? _value.topSellingProducts
                : topSellingProducts // ignore: cast_nullable_to_non_nullable
                      as List<ProductSales>,
            dailySalesData: null == dailySalesData
                ? _value.dailySalesData
                : dailySalesData // ignore: cast_nullable_to_non_nullable
                      as Map<DateTime, double>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            orders: null == orders
                ? _value.orders
                : orders // ignore: cast_nullable_to_non_nullable
                      as List<Order>,
            hourlyOrderCounts: null == hourlyOrderCounts
                ? _value.hourlyOrderCounts
                : hourlyOrderCounts // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
            tableReports: null == tableReports
                ? _value.tableReports
                : tableReports // ignore: cast_nullable_to_non_nullable
                      as Map<String, TableReport>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportDataImplCopyWith<$Res>
    implements $ReportDataCopyWith<$Res> {
  factory _$$ReportDataImplCopyWith(
    _$ReportDataImpl value,
    $Res Function(_$ReportDataImpl) then,
  ) = __$$ReportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalSales,
    int totalOrders,
    double averageOrderValue,
    double totalDiscountGiven,
    Map<String, double> salesByPaymentMethod,
    List<ProductSales> topSellingProducts,
    Map<DateTime, double> dailySalesData,
    bool isLoading,
    String? errorMessage,
    List<Order> orders,
    Map<int, int> hourlyOrderCounts,
    Map<String, TableReport> tableReports,
  });
}

/// @nodoc
class __$$ReportDataImplCopyWithImpl<$Res>
    extends _$ReportDataCopyWithImpl<$Res, _$ReportDataImpl>
    implements _$$ReportDataImplCopyWith<$Res> {
  __$$ReportDataImplCopyWithImpl(
    _$ReportDataImpl _value,
    $Res Function(_$ReportDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSales = null,
    Object? totalOrders = null,
    Object? averageOrderValue = null,
    Object? totalDiscountGiven = null,
    Object? salesByPaymentMethod = null,
    Object? topSellingProducts = null,
    Object? dailySalesData = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? orders = null,
    Object? hourlyOrderCounts = null,
    Object? tableReports = null,
  }) {
    return _then(
      _$ReportDataImpl(
        totalSales: null == totalSales
            ? _value.totalSales
            : totalSales // ignore: cast_nullable_to_non_nullable
                  as double,
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        averageOrderValue: null == averageOrderValue
            ? _value.averageOrderValue
            : averageOrderValue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalDiscountGiven: null == totalDiscountGiven
            ? _value.totalDiscountGiven
            : totalDiscountGiven // ignore: cast_nullable_to_non_nullable
                  as double,
        salesByPaymentMethod: null == salesByPaymentMethod
            ? _value._salesByPaymentMethod
            : salesByPaymentMethod // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        topSellingProducts: null == topSellingProducts
            ? _value._topSellingProducts
            : topSellingProducts // ignore: cast_nullable_to_non_nullable
                  as List<ProductSales>,
        dailySalesData: null == dailySalesData
            ? _value._dailySalesData
            : dailySalesData // ignore: cast_nullable_to_non_nullable
                  as Map<DateTime, double>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        orders: null == orders
            ? _value._orders
            : orders // ignore: cast_nullable_to_non_nullable
                  as List<Order>,
        hourlyOrderCounts: null == hourlyOrderCounts
            ? _value._hourlyOrderCounts
            : hourlyOrderCounts // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
        tableReports: null == tableReports
            ? _value._tableReports
            : tableReports // ignore: cast_nullable_to_non_nullable
                  as Map<String, TableReport>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportDataImpl implements _ReportData {
  const _$ReportDataImpl({
    this.totalSales = 0.0,
    this.totalOrders = 0,
    this.averageOrderValue = 0.0,
    this.totalDiscountGiven = 0.0,
    final Map<String, double> salesByPaymentMethod = const {},
    final List<ProductSales> topSellingProducts = const [],
    final Map<DateTime, double> dailySalesData = const {},
    this.isLoading = false,
    this.errorMessage,
    final List<Order> orders = const [],
    final Map<int, int> hourlyOrderCounts = const {},
    final Map<String, TableReport> tableReports = const {},
  }) : _salesByPaymentMethod = salesByPaymentMethod,
       _topSellingProducts = topSellingProducts,
       _dailySalesData = dailySalesData,
       _orders = orders,
       _hourlyOrderCounts = hourlyOrderCounts,
       _tableReports = tableReports;

  factory _$ReportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportDataImplFromJson(json);

  @override
  @JsonKey()
  final double totalSales;
  // Toplam satış hacmi
  @override
  @JsonKey()
  final int totalOrders;
  // Toplam sipariş sayısı
  @override
  @JsonKey()
  final double averageOrderValue;
  // Ortalama sipariş tutarı
  @override
  @JsonKey()
  final double totalDiscountGiven;
  // Uygulanan toplam indirim
  final Map<String, double> _salesByPaymentMethod;
  // Uygulanan toplam indirim
  @override
  @JsonKey()
  Map<String, double> get salesByPaymentMethod {
    if (_salesByPaymentMethod is EqualUnmodifiableMapView)
      return _salesByPaymentMethod;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_salesByPaymentMethod);
  }

  // Örn: {'Nakit': 1000.0, 'Kart': 500.0}
  final List<ProductSales> _topSellingProducts;
  // Örn: {'Nakit': 1000.0, 'Kart': 500.0}
  @override
  @JsonKey()
  List<ProductSales> get topSellingProducts {
    if (_topSellingProducts is EqualUnmodifiableListView)
      return _topSellingProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topSellingProducts);
  }

  // En çok satan ürünler
  final Map<DateTime, double> _dailySalesData;
  // En çok satan ürünler
  @override
  @JsonKey()
  Map<DateTime, double> get dailySalesData {
    if (_dailySalesData is EqualUnmodifiableMapView) return _dailySalesData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailySalesData);
  }

  // Günlük satış verileri {DateTime(yıl, ay, gün): toplamSatış}
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  final List<Order> _orders;
  @override
  @JsonKey()
  List<Order> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  // Raporlanan siparişler
  final Map<int, int> _hourlyOrderCounts;
  // Raporlanan siparişler
  @override
  @JsonKey()
  Map<int, int> get hourlyOrderCounts {
    if (_hourlyOrderCounts is EqualUnmodifiableMapView)
      return _hourlyOrderCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_hourlyOrderCounts);
  }

  // Saatlik sipariş yoğunluğu
  final Map<String, TableReport> _tableReports;
  // Saatlik sipariş yoğunluğu
  @override
  @JsonKey()
  Map<String, TableReport> get tableReports {
    if (_tableReports is EqualUnmodifiableMapView) return _tableReports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tableReports);
  }

  @override
  String toString() {
    return 'ReportData(totalSales: $totalSales, totalOrders: $totalOrders, averageOrderValue: $averageOrderValue, totalDiscountGiven: $totalDiscountGiven, salesByPaymentMethod: $salesByPaymentMethod, topSellingProducts: $topSellingProducts, dailySalesData: $dailySalesData, isLoading: $isLoading, errorMessage: $errorMessage, orders: $orders, hourlyOrderCounts: $hourlyOrderCounts, tableReports: $tableReports)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDataImpl &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.averageOrderValue, averageOrderValue) ||
                other.averageOrderValue == averageOrderValue) &&
            (identical(other.totalDiscountGiven, totalDiscountGiven) ||
                other.totalDiscountGiven == totalDiscountGiven) &&
            const DeepCollectionEquality().equals(
              other._salesByPaymentMethod,
              _salesByPaymentMethod,
            ) &&
            const DeepCollectionEquality().equals(
              other._topSellingProducts,
              _topSellingProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._dailySalesData,
              _dailySalesData,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            const DeepCollectionEquality().equals(
              other._hourlyOrderCounts,
              _hourlyOrderCounts,
            ) &&
            const DeepCollectionEquality().equals(
              other._tableReports,
              _tableReports,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalSales,
    totalOrders,
    averageOrderValue,
    totalDiscountGiven,
    const DeepCollectionEquality().hash(_salesByPaymentMethod),
    const DeepCollectionEquality().hash(_topSellingProducts),
    const DeepCollectionEquality().hash(_dailySalesData),
    isLoading,
    errorMessage,
    const DeepCollectionEquality().hash(_orders),
    const DeepCollectionEquality().hash(_hourlyOrderCounts),
    const DeepCollectionEquality().hash(_tableReports),
  );

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      __$$ReportDataImplCopyWithImpl<_$ReportDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportDataImplToJson(this);
  }
}

abstract class _ReportData implements ReportData {
  const factory _ReportData({
    final double totalSales,
    final int totalOrders,
    final double averageOrderValue,
    final double totalDiscountGiven,
    final Map<String, double> salesByPaymentMethod,
    final List<ProductSales> topSellingProducts,
    final Map<DateTime, double> dailySalesData,
    final bool isLoading,
    final String? errorMessage,
    final List<Order> orders,
    final Map<int, int> hourlyOrderCounts,
    final Map<String, TableReport> tableReports,
  }) = _$ReportDataImpl;

  factory _ReportData.fromJson(Map<String, dynamic> json) =
      _$ReportDataImpl.fromJson;

  @override
  double get totalSales; // Toplam satış hacmi
  @override
  int get totalOrders; // Toplam sipariş sayısı
  @override
  double get averageOrderValue; // Ortalama sipariş tutarı
  @override
  double get totalDiscountGiven; // Uygulanan toplam indirim
  @override
  Map<String, double> get salesByPaymentMethod; // Örn: {'Nakit': 1000.0, 'Kart': 500.0}
  @override
  List<ProductSales> get topSellingProducts; // En çok satan ürünler
  @override
  Map<DateTime, double> get dailySalesData; // Günlük satış verileri {DateTime(yıl, ay, gün): toplamSatış}
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  List<Order> get orders; // Raporlanan siparişler
  @override
  Map<int, int> get hourlyOrderCounts; // Saatlik sipariş yoğunluğu
  @override
  Map<String, TableReport> get tableReports;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
