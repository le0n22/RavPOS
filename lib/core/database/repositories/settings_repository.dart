import 'package:ravpos/shared/models/settings.dart';
import 'package:ravpos/core/network/api_service.dart';

class SettingsRepository {
  final ApiService apiService;
  SettingsRepository(this.apiService);

  Future<List<Settings>> getAllSettings() async {
    final response = await apiService.get('/settings');
    final List<dynamic> data = response.data;
    return data.map((json) => Settings.fromJson(json)).toList();
  }

  Future<Settings> getSetting(String key) async {
    final response = await apiService.get('/settings/$key');
    return Settings.fromJson(response.data);
  }

  Future<Settings> createSetting(Settings setting) async {
    final response = await apiService.post('/settings', data: setting.toJson());
    return Settings.fromJson(response.data);
  }

  Future<Settings> updateSetting(String key, dynamic value) async {
    final response = await apiService.put('/settings/$key', data: {'value': value});
    return Settings.fromJson(response.data);
  }

  Future<void> deleteSetting(String key) async {
    await apiService.delete('/settings/$key');
  }
} 