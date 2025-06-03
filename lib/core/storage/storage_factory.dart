import 'package:ravpos/core/utils/platform_helper.dart';
import 'storage_interface.dart';
import 'dart:async';

class StorageFactory {
  static final StorageFactory _instance = StorageFactory._internal();
  static StorageInterface? _storageInstance;
  static final _initCompleter = Completer<StorageInterface>();
  static bool _isInitializing = false;

  factory StorageFactory() => _instance;

  StorageFactory._internal();

  /// Returns the appropriate storage implementation based on the platform
  static Future<StorageInterface> getInstance() async {
    throw UnimplementedError('All storage is now backend-driven.');
  }

  /// Closes the storage instance if open
  static Future<void> closeStorage() async {
    _storageInstance = null;
  }
} 