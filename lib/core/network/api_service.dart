import 'package:dio/dio.dart' as dio_lib;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ravpos/core/storage/token_storage.dart';
import 'package:ravpos/core/database/repositories/user_repository.dart';
import 'package:ravpos/core/storage/storage_factory.dart';
import 'package:ravpos/core/storage/storage_interface.dart';
import 'package:ravpos/shared/models/table.dart';
import 'dart:convert';

class ApiService {
  final dio_lib.Dio _dio;
  dio_lib.Dio get dio => _dio;
  final TokenStorage _tokenStorage = TokenStorage();
  bool _isRefreshing = false;

  ApiService({dio_lib.Dio? dioClient})
      : _dio = dioClient ?? dio_lib.Dio() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add a logging interceptor in debug mode
    _dio.interceptors.add(dio_lib.LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    // Add JWT interceptor
    _dio.interceptors.add(dio_lib.InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _tokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (dio_lib.DioException error, handler) async {
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;
          try {
            final userRepository = UserRepository(this);
            final refreshed = await userRepository.refreshToken();
            if (refreshed) {
              String? newToken = await _tokenStorage.getToken();
              if (newToken != null) {
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final opts = dio_lib.Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                );
                final cloneReq = await _dio.request(
                  error.requestOptions.path,
                  options: opts,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                _isRefreshing = false;
                return handler.resolve(cloneReq);
              }
            } else {
              await userRepository.logout();
            }
          } catch (e) {
            // ignore
          } finally {
            _isRefreshing = false;
          }
        }
        return handler.next(error);
      },
    ));
  }

  // HTTP GET request
  Future<dio_lib.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on dio_lib.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // HTTP POST request
  Future<dio_lib.Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on dio_lib.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // HTTP PUT request
  Future<dio_lib.Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on dio_lib.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // HTTP PATCH request
  Future<dio_lib.Response> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response;
    } on dio_lib.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // HTTP DELETE request
  Future<dio_lib.Response> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return response;
    } on dio_lib.DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling helper
  Exception _handleError(dio_lib.DioException e) {
    String errorMessage = 'An error occurred';
    
    switch (e.type) {
      case dio_lib.DioExceptionType.connectionTimeout:
      case dio_lib.DioExceptionType.sendTimeout:
      case dio_lib.DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timeout. Please check your internet connection';
        break;
      case dio_lib.DioExceptionType.badResponse:
        errorMessage = 'Bad response from server: ${e.response?.statusCode}';
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
        break;
      case dio_lib.DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
        break;
      case dio_lib.DioExceptionType.connectionError:
        errorMessage = 'Connection error. Please check your internet connection';
        break;
      case dio_lib.DioExceptionType.badCertificate:
        errorMessage = 'Bad certificate. Connection not secure';
        break;
      case dio_lib.DioExceptionType.unknown:
        errorMessage = 'Unknown error: ${e.message}';
        break;
    }
    
    return Exception(errorMessage);
  }

  Future<List<RestaurantTable>> getTables() async {
    try {
      final response = await get('/api/tables');
      print('🔵 RAW TABLES RESPONSE: \\${jsonEncode(response.data)}');
      final tables = (response.data as List)
          .map((json) => RestaurantTable.fromJson(json))
          .toList();
      print('🟢 PARSED TABLES:');
      tables.forEach((t) => print(t.toString()));
      return tables;
    } catch (e) {
      print('🔴 TABLE FETCH ERROR: \\${e}');
      rethrow;
    }
  }
}

// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});