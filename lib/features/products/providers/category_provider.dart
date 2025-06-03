import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/category.dart';
import '../../../core/network/api_service.dart';
import '../../../core/database/repositories/category_repository.dart';

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  late final CategoryRepository _repository;
  bool _isInitialized = false;
  List<Category> _cachedCategories = [];

  @override
  Future<List<Category>> build() async {
    final apiService = ref.read(apiServiceProvider);
    _repository = CategoryRepository(apiService);
    return loadCategories();
  }

  Future<List<Category>> loadCategories() async {
    try {
      // Return cached data immediately if available
      if (_isInitialized && _cachedCategories.isNotEmpty) {
        // Use microtask to refresh in background
        Future.microtask(() async {
          try {
            final categories = await _repository.getCategories();
            if (categories.isNotEmpty) {
              _cachedCategories = _sortCategories(categories);
              state = AsyncData(_cachedCategories);
            }
          } catch (e) {
            // print('Background category refresh error: $e');
          }
        });
        
        return _cachedCategories;
      }
      
      // If no cache, show loading and load data
      state = const AsyncLoading();
      final categories = await _repository.getCategories();
      
      // Sort categories by display order
      _cachedCategories = _sortCategories(categories);
      _isInitialized = true;
      
      state = AsyncData(_cachedCategories);
      return _cachedCategories;
    } catch (e, stack) {
      // print('Error loading categories: $e');
      state = AsyncError(e, stack);
      return [];
    }
  }

  // Helper method to sort categories
  List<Category> _sortCategories(List<Category> categories) {
    // First active categories, then sort by display order
    return categories
      ..sort((a, b) {
        // First sort by active status (active first)
        if (a.isActive != b.isActive) {
          return a.isActive ? -1 : 1;
        }
        // Then sort by display order
        return a.displayOrder.compareTo(b.displayOrder);
      });
  }

  Future<bool> addCategory(Category category) async {
    try {
      final result = await _repository.insertCategory(category);
      if (result.isNotEmpty) {
        // Reload and update the cache
        final categories = await _repository.getCategories();
        _cachedCategories = _sortCategories(categories);
        state = AsyncData(_cachedCategories);
        return true;
      }
      return false;
    } catch (e) {
      // print('Error adding category: $e');
      return false;
    }
  }

  Future<bool> updateCategory(Category category) async {
    try {
      final result = await _repository.updateCategory(category);
      if (result > 0) {
        // Reload and update the cache
        final categories = await _repository.getCategories();
        _cachedCategories = _sortCategories(categories);
        state = AsyncData(_cachedCategories);
        return true;
      }
      return false;
    } catch (e) {
      // print('Error updating category: $e');
      return false;
    }
  }

  Future<List<Category>> getActiveCategories() async {
    // If we already have cached categories, filter the active ones
    if (_isInitialized && _cachedCategories.isNotEmpty) {
      final activeCategories = _cachedCategories
        .where((c) => c.isActive)
        .toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      
      return activeCategories;
    }
    
    // Otherwise load from repository
    state = const AsyncLoading();
    try {
      final categories = await _repository.getCategories();
      final sortedCategories = categories
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      
      state = AsyncData(sortedCategories);
      return sortedCategories;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }
  
  // Force refresh and clear cache
  Future<List<Category>> forceRefresh() async {
    _isInitialized = false;
    _cachedCategories.clear();
    return loadCategories();
  }
  
  Future<bool> deleteCategory(String id) async {
    try {
      final result = await _repository.deleteCategory(id);
      if (result > 0) {
        // Reload and update the cache
        final categories = await _repository.getCategories();
        _cachedCategories = _sortCategories(categories);
        state = AsyncData(_cachedCategories);
        return true;
      }
      return false;
    } catch (e) {
      // print('Error deleting category: $e');
      return false;
    }
  }
}

final categoryProvider = AsyncNotifierProvider<CategoryNotifier, List<Category>>(
  () => CategoryNotifier(),
); 