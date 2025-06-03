// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      restaurantName: json['restaurantName'] as String? ?? 'RavPOS Restaurant',
      printerIp: json['printerIp'] as String? ?? '',
      printerPort: json['printerPort'] as String? ?? '9100',
      printerMac: json['printerMac'] as String? ?? '',
      useBluetoothPrinter: json['useBluetoothPrinter'] as bool? ?? false,
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      showTables: json['showTables'] as bool? ?? true,
      enableOnlineOrders: json['enableOnlineOrders'] as bool? ?? false,
      apiServerIp: json['apiServerIp'] as String? ?? '0.0.0.0',
      apiServerPort: json['apiServerPort'] as String? ?? '8080',
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'restaurantName': instance.restaurantName,
      'printerIp': instance.printerIp,
      'printerPort': instance.printerPort,
      'printerMac': instance.printerMac,
      'useBluetoothPrinter': instance.useBluetoothPrinter,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'showTables': instance.showTables,
      'enableOnlineOrders': instance.enableOnlineOrders,
      'apiServerIp': instance.apiServerIp,
      'apiServerPort': instance.apiServerPort,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
