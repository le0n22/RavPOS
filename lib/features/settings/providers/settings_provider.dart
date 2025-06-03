import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/repositories/settings_repository.dart';
import '../../../shared/models/settings.dart';
import '../../../core/network/api_service.dart';

class SettingsNotifier extends AsyncNotifier<List<Settings>> {
  late final SettingsRepository _repository;

  @override
  Future<List<Settings>> build() async {
    _repository = SettingsRepository(ref.read(apiServiceProvider));
    return fetchAllSettings();
  }

  Future<List<Settings>> fetchAllSettings() async {
    state = const AsyncLoading();
    try {
      final settings = await _repository.getAllSettings();
      state = AsyncData(settings);
      return settings;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<Settings?> fetchSetting(String key) async {
    try {
      return await _repository.getSetting(key);
    } catch (e) {
      return null;
    }
  }

  Future<Settings?> createSetting(Settings setting) async {
    try {
      final created = await _repository.createSetting(setting);
      await fetchAllSettings();
      return created;
    } catch (e) {
      return null;
    }
  }

  Future<Settings?> updateSetting(String key, dynamic value) async {
    try {
      final updated = await _repository.updateSetting(key, value);
      await fetchAllSettings();
      return updated;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteSetting(String key) async {
    try {
      await _repository.deleteSetting(key);
      await fetchAllSettings();
    } catch (e) {}
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, List<Settings>>(
  () => SettingsNotifier(),
); 