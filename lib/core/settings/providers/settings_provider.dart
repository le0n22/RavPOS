import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.freezed.dart';
part 'settings_provider.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('RavPOS Restaurant') String restaurantName,
    @Default('') String printerIp,
    @Default('9100') String printerPort,
    @Default('') String printerMac,
    @Default(false) bool useBluetoothPrinter,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool showTables,
    @Default(false) bool enableOnlineOrders,
    @Default('0.0.0.0') String apiServerIp,
    @Default('8080') String apiServerPort,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}

class SettingsNotifier extends Notifier<AppSettings> {
  static const String _settingsKey = 'app_settings';

  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      if (settingsJson != null) {
        final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
        if (settingsMap.containsKey('themeMode')) {
          final themeModeIndex = settingsMap['themeMode'];
          settingsMap['themeMode'] = ThemeMode.values[themeModeIndex];
        }
        state = AppSettings.fromJson(settingsMap);
      }
    } catch (e) {
      // Keep default settings if there's an error
    }
  }

  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsMap = state.toJson();
      settingsMap['themeMode'] = state.themeMode.index;
      final settingsJson = jsonEncode(settingsMap);
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      // Handle error
    }
  }

  void updateRestaurantName(String name) {
    state = state.copyWith(restaurantName: name);
    saveSettings();
  }

  void updateShowTables(bool showTables) {
    state = state.copyWith(showTables: showTables);
    saveSettings();
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
    saveSettings();
  }

  void updateUseBluetoothPrinter(bool useBluetoothPrinter) {
    state = state.copyWith(useBluetoothPrinter: useBluetoothPrinter);
    saveSettings();
  }

  void updatePrinterMac(String mac) {
    state = state.copyWith(printerMac: mac);
    saveSettings();
  }

  void updatePrinterIp(String ip) {
    state = state.copyWith(printerIp: ip);
    saveSettings();
  }

  void updatePrinterPort(String port) {
    state = state.copyWith(printerPort: port);
    saveSettings();
  }

  void updateEnableOnlineOrders(bool enableOnlineOrders) {
    state = state.copyWith(enableOnlineOrders: enableOnlineOrders);
    saveSettings();
  }

  void updateApiServerIp(String ip) {
    state = state.copyWith(apiServerIp: ip);
    saveSettings();
  }

  void updateApiServerPort(String port) {
    state = state.copyWith(apiServerPort: port);
    saveSettings();
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
}); 