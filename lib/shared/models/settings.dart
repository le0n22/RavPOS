import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

enum SettingType { string, int, double, bool, json }

@freezed
class Settings with _$Settings {
  const factory Settings({
    required String id,
    required String key,
    required dynamic value,
    required SettingType type,
    String? description,
    DateTime? updatedAt,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
} 