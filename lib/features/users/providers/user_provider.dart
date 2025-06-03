import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:ravpos/core/database/repositories/user_repository.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:ravpos/core/network/api_service.dart';
import 'dart:convert';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return UserRepository(apiService);
});

class UserNotifier extends AsyncNotifier<List<AppUser>> {
  final _uuid = Uuid();
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  @override
  Future<List<AppUser>> build() async {
    return loadUsers();
  }

  Future<List<AppUser>> loadUsers() async {
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final users = await userRepository.getAllUsers();
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<void> addUser(AppUser user) async {
    try {
      state = const AsyncValue.loading();
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.insertUser(user);
      state = AsyncValue.data(await loadUsers());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateUser(AppUser user) async {
    try {
      state = const AsyncValue.loading();
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.updateUser(user);
      state = AsyncValue.data(await loadUsers());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      state = const AsyncValue.loading();
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.deleteUser(id);
      state = AsyncValue.data(await loadUsers());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<AppUser?> login(String username, String password) async {
    final userRepository = ref.read(userRepositoryProvider);
    final user = await userRepository.login(username, password);
    if (user != null) {
      _currentUser = user;
      ref.notifyListeners();
    }
    return user;
  }

  Future<AppUser?> register(AppUser user, String password) async {
    final userRepository = ref.read(userRepositoryProvider);
    final newUser = await userRepository.register(user, password);
    if (newUser != null) {
      _currentUser = newUser;
      ref.notifyListeners();
    }
    return newUser;
  }

  void logout() {
    _currentUser = null;
    ref.notifyListeners();
  }

  Future<void> autoLogin() async {
    final userRepository = ref.read(userRepositoryProvider);
    final token = await userRepository.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        // Decode JWT to get userId
        final parts = token.split('.');
        if (parts.length != 3) throw Exception('Invalid token');
        final payload = String.fromCharCodes(base64Url.decode(base64Url.normalize(parts[1])));
        final userId = (jsonDecode(payload)['userId'] ?? jsonDecode(payload)['id'])?.toString();
        if (userId == null) throw Exception('No userId in token');
        final response = await userRepository.apiService.get('/users/$userId');
        _currentUser = AppUser.fromJson(response.data);
        ref.notifyListeners();
      } catch (e) {
        // Token invalid or expired, clear it
        await userRepository.logout();
        _currentUser = null;
        ref.notifyListeners();
      }
    }
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, List<AppUser>>(() {
  return UserNotifier();
});

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(userProvider.notifier).currentUser;
});

final currentUserAsyncProvider = Provider<AsyncValue<AppUser?>>((ref) {
  final notifier = ref.watch(userProvider.notifier);
  final state = ref.watch(userProvider);
  return state.when(
    data: (_) => AsyncValue.data(notifier.currentUser),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
}); 