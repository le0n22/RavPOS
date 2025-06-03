import 'package:dio/dio.dart';
import 'package:ravpos/core/network/api_service.dart';
import 'package:ravpos/shared/models/app_user.dart';
import 'package:ravpos/core/storage/storage_factory.dart';
import 'package:ravpos/core/storage/storage_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ravpos/core/storage/token_storage.dart';

class UserRepository {
  final ApiService apiService;
  final TokenStorage _tokenStorage = TokenStorage();

  UserRepository(this.apiService);

  Future<List<AppUser>> getAllUsers() async {
    final response = await apiService.get('/users');
    final List<dynamic> data = response.data;
    return data.map((json) => AppUser.fromJson(json)).toList();
  }

  Future<AppUser?> getUserById(String id) async {
    final response = await apiService.get('/users/$id');
    return AppUser.fromJson(response.data);
  }

  Future<String> insertUser(AppUser user) async {
    final response = await apiService.post('/users', data: user.toJson());
    return response.data['id'] as String;
  }

  Future<int> updateUser(AppUser user) async {
    final response = await apiService.put('/users/${user.id}', data: user.toJson());
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<int> deleteUser(String id) async {
    final response = await apiService.delete('/users/$id');
    return response.statusCode == 200 ? 1 : 0;
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await _tokenStorage.setRefreshToken(refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _tokenStorage.getRefreshToken();
  }

  Future<void> clearRefreshToken() async {
    await _tokenStorage.clearRefreshToken();
  }

  Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;
    try {
      final response = await apiService.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      if (response.statusCode == 200 && response.data['token'] != null) {
        await setToken(response.data['token']);
        if (response.data['refreshToken'] != null) {
          await setRefreshToken(response.data['refreshToken']);
        }
        return true;
      }
    } catch (e) {
      // ignore
    }
    await logout();
    await clearRefreshToken();
    return false;
  }

  Future<AppUser?> login(String username, String password) async {
    final response = await apiService.post('/auth/login', data: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final token = response.data['token'];
      final refreshToken = response.data['refreshToken'];
      if (token != null) {
        await setToken(token);
      }
      if (refreshToken != null) {
        await setRefreshToken(refreshToken);
      }
      return AppUser.fromJson(response.data['user']);
    }
    return null;
  }

  Future<AppUser?> register(AppUser user, String password) async {
    final response = await apiService.post('/auth/register', data: {
      ...user.toJson(),
      'password': password,
    });
    if (response.statusCode == 200) {
      return AppUser.fromJson(response.data['user']);
    }
    return null;
  }

  Future<void> logout() async {
    await clearToken();
    await clearRefreshToken();
  }

  Future<void> setToken(String token) async {
    await _tokenStorage.setToken(token);
  }

  Future<void> clearToken() async {
    await _tokenStorage.clearToken();
  }

  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }
} 