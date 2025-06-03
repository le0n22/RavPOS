// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Printer _$PrinterFromJson(Map<String, dynamic> json) {
  return _Printer.fromJson(json);
}

/// @nodoc
mixin _$Printer {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  PrinterType get type => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  DateTime? get lastUsed => throw _privateConstructorUsedError;

  /// Serializes this Printer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Printer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterCopyWith<Printer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterCopyWith<$Res> {
  factory $PrinterCopyWith(Printer value, $Res Function(Printer) then) =
      _$PrinterCopyWithImpl<$Res, Printer>;
  @useResult
  $Res call({
    String id,
    String name,
    PrinterType type,
    String ipAddress,
    int port,
    bool isActive,
    String? location,
    DateTime? lastUsed,
  });
}

/// @nodoc
class _$PrinterCopyWithImpl<$Res, $Val extends Printer>
    implements $PrinterCopyWith<$Res> {
  _$PrinterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Printer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? isActive = null,
    Object? location = freezed,
    Object? lastUsed = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PrinterType,
            ipAddress: null == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            port: null == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastUsed: freezed == lastUsed
                ? _value.lastUsed
                : lastUsed // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrinterImplCopyWith<$Res> implements $PrinterCopyWith<$Res> {
  factory _$$PrinterImplCopyWith(
    _$PrinterImpl value,
    $Res Function(_$PrinterImpl) then,
  ) = __$$PrinterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    PrinterType type,
    String ipAddress,
    int port,
    bool isActive,
    String? location,
    DateTime? lastUsed,
  });
}

/// @nodoc
class __$$PrinterImplCopyWithImpl<$Res>
    extends _$PrinterCopyWithImpl<$Res, _$PrinterImpl>
    implements _$$PrinterImplCopyWith<$Res> {
  __$$PrinterImplCopyWithImpl(
    _$PrinterImpl _value,
    $Res Function(_$PrinterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Printer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? isActive = null,
    Object? location = freezed,
    Object? lastUsed = freezed,
  }) {
    return _then(
      _$PrinterImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PrinterType,
        ipAddress: null == ipAddress
            ? _value.ipAddress
            : ipAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        port: null == port
            ? _value.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastUsed: freezed == lastUsed
            ? _value.lastUsed
            : lastUsed // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterImpl implements _Printer {
  const _$PrinterImpl({
    required this.id,
    required this.name,
    required this.type,
    required this.ipAddress,
    required this.port,
    this.isActive = true,
    this.location,
    this.lastUsed,
  });

  factory _$PrinterImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final PrinterType type;
  @override
  final String ipAddress;
  @override
  final int port;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? location;
  @override
  final DateTime? lastUsed;

  @override
  String toString() {
    return 'Printer(id: $id, name: $name, type: $type, ipAddress: $ipAddress, port: $port, isActive: $isActive, location: $location, lastUsed: $lastUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    ipAddress,
    port,
    isActive,
    location,
    lastUsed,
  );

  /// Create a copy of Printer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterImplCopyWith<_$PrinterImpl> get copyWith =>
      __$$PrinterImplCopyWithImpl<_$PrinterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterImplToJson(this);
  }
}

abstract class _Printer implements Printer {
  const factory _Printer({
    required final String id,
    required final String name,
    required final PrinterType type,
    required final String ipAddress,
    required final int port,
    final bool isActive,
    final String? location,
    final DateTime? lastUsed,
  }) = _$PrinterImpl;

  factory _Printer.fromJson(Map<String, dynamic> json) = _$PrinterImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  PrinterType get type;
  @override
  String get ipAddress;
  @override
  int get port;
  @override
  bool get isActive;
  @override
  String? get location;
  @override
  DateTime? get lastUsed;

  /// Create a copy of Printer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterImplCopyWith<_$PrinterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
