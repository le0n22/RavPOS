import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/product.dart';
import '../../../core/network/api_service.dart';
import '../../../core/database/repositories/product_repository.dart';
import '../../../core/database/repositories/discount_repository.dart';
import '../../../shared/models/discount.dart';

class ProductNotifier extends AsyncNotifier<List<Product>> {
  late final ApiService _apiService;
  bool _isInitialized = false;
  List<Product> _cachedProducts = [];
  // Cache products by category to avoid reloading
  final Map<String, List<Product>> _productsByCategory = {};
  ProductRepository get _repository => ProductRepository(_apiService);

  @override
  Future<List<Product>> build() async {
    _apiService = ref.read(apiServiceProvider);
    return loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    try {
      // Return cached data immediately if available while refreshing in background
      if (_isInitialized && _cachedProducts.isNotEmpty) {
        // Use microTask to avoid modifying state during build
        Future.microtask(() async {
          try {
            final products = await _fetchProducts();
            if (products.isNotEmpty) {
              _cachedProducts = products;
              // Check if notifier is still active before updating state
              if (!state.isLoading) {
                state = AsyncData(products);
              }
            }
          } catch (e) {
            // Don't update state on background refresh error
          }
        });
        
        return _cachedProducts;
      }
      
      // If no cache, show loading and load data
      state = const AsyncLoading();
      final products = await _fetchProducts();
      
      if (products.isNotEmpty) {
        _cachedProducts = products;
        _isInitialized = true;
      }
      
      state = AsyncData(_cachedProducts);
      return _cachedProducts;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<List<Product>> _fetchProducts() async {
    final response = await _apiService.get('/products');
    final List<dynamic> data = response.data;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> loadProductsByCategory(String categoryId) async {
    try {
      // Return cached category data immediately if available
      if (_productsByCategory.containsKey(categoryId) && 
          _productsByCategory[categoryId]!.isNotEmpty) {
        // Use microTask to avoid modifying state during build
        Future.microtask(() async {
          try {
            state = AsyncData(_productsByCategory[categoryId]!);
            
            // Refresh in background
            final products = await _fetchProducts();
            if (products.isNotEmpty) {
              _productsByCategory[categoryId] = products;
              // Check if notifier is still active before updating state
              if (!state.isLoading) {
                state = AsyncData(products);
              }
            }
          } catch (e) {
            // Don't update state on background refresh error
          }
        });
        
        return _productsByCategory[categoryId]!;
      }
      
      // If no cache, show loading and load data
      state = AsyncLoading();
      final products = await _fetchProducts();
      
      // Cache the results by category
      _productsByCategory[categoryId] = products;
      
      state = AsyncData(products);
      return products;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    // Search in cached products first for better performance
    if (_cachedProducts.isNotEmpty) {
      final filteredProducts = _cachedProducts.where((product) => 
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
      ).toList();
      
      state = AsyncData(filteredProducts);
      return filteredProducts;
    }
    
    // If no cache, perform search against repository
    state = const AsyncLoading();
    try {
      final products = await _fetchProducts();
      state = AsyncData(products);
      return products;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      final success = await _repository.insertProduct(product);
      if (success) {
        await loadProducts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      final result = await _fetchProducts();
      if (result.isNotEmpty) {
        // Update the cache
        _cachedProducts = result;
        _productsByCategory.clear(); // Clear category cache
        state = AsyncData(_cachedProducts);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleProductAvailability(String productId) async {
    try {
      final product = await _fetchProducts();
      if (product.isNotEmpty) {
        final updatedProduct = product.firstWhere((p) => p.id == productId).copyWith(isAvailable: !product.firstWhere((p) => p.id == productId).isAvailable);
        final result = await _fetchProducts();
        if (result.isNotEmpty) {
          // Update the cache
          _cachedProducts = result;
          _productsByCategory.clear(); // Clear category cache
          state = AsyncData(_cachedProducts);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Force refresh all data and clear cache
  Future<List<Product>> forceRefresh() async {
    _isInitialized = false;
    _cachedProducts.clear();
    _productsByCategory.clear();
    return loadProducts();
  }
  
  Future<bool> deleteProduct(String id) async {
    try {
      final result = await _fetchProducts();
      if (result.isNotEmpty) {
        // Update the cache
        _cachedProducts = result;
        _productsByCategory.clear(); // Clear category cache
        state = AsyncData(_cachedProducts);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<int> getStockLevel(String productId) async {
    return await _repository.getStockLevel(productId);
  }

  Future<void> updateStockLevel(String productId, int newStock) async {
    await _repository.updateStockLevel(productId, newStock);
    _cachedProducts = await _repository.getAllProducts();
    state = AsyncData(_cachedProducts);
  }

  Future<void> adjustStock(String productId, int delta) async {
    await _repository.adjustStock(productId, delta);
    _cachedProducts = await _repository.getAllProducts();
    state = AsyncData(_cachedProducts);
  }
}

final productProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(
  () => ProductNotifier(),
);

class DiscountNotifier extends AsyncNotifier<List<Discount>> {
  late final DiscountRepository _repository;

  @override
  Future<List<Discount>> build() async {
    _repository = DiscountRepository(ref.read(apiServiceProvider));
    return fetchAllDiscounts();
  }

  Future<List<Discount>> fetchAllDiscounts() async {
    state = const AsyncLoading();
    try {
      final discounts = await _repository.getAllDiscounts();
      state = AsyncData(discounts);
      return discounts;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<List<Discount>> fetchActiveDiscounts() async {
    state = const AsyncLoading();
    try {
      final discounts = await _repository.getActiveDiscounts();
      state = AsyncData(discounts);
      return discounts;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<Discount?> createDiscount(Discount discount) async {
    try {
      final created = await _repository.createDiscount(discount);
      await fetchAllDiscounts();
      return created;
    } catch (e) {
      return null;
    }
  }

  Future<Discount?> updateDiscount(Discount discount) async {
    try {
      final updated = await _repository.updateDiscount(discount);
      await fetchAllDiscounts();
      return updated;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteDiscount(String id) async {
    try {
      await _repository.deleteDiscount(id);
      await fetchAllDiscounts();
    } catch (e) {}
  }

  Future<void> applyDiscountToOrder(String orderId, String discountId) async {
    await _repository.applyDiscountToOrder(orderId, discountId);
  }
}

final discountProvider = AsyncNotifierProvider<DiscountNotifier, List<Discount>>(
  () => DiscountNotifier(),
); 