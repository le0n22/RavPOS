import 'package:ravpos/shared/models/models.dart';

abstract class StorageInterface {
  Future<void> init();
  Future<void> close();

  // Categories
  Future<List<Category>> getCategories();
  Future<Category?> getCategoryById(String id);
  Future<String> insertCategory(Category category);
  Future<int> updateCategory(Category category);
  Future<int> deleteCategory(String id);

  // Products
  Future<List<Product>> getProducts();
  Future<List<Product>> getProductsByCategory(String categoryId);
  Future<Product?> getProductById(String id);
  Future<String> insertProduct(Product product);
  Future<int> updateProduct(Product product);
  Future<int> deleteProduct(String id);

  // Orders
  Future<List<Order>> getOrders();
  Future<Order?> getOrderById(String id);
  Future<List<Order>> getOrdersByTable(String tableIdentifier);
  Future<Order?> getLatestOrderByTable(String tableIdentifier);
  Future<String> insertOrder(Order order, List<OrderItem> items);
  Future<int> updateOrder(Order order);
  Future<int> updateOrderStatus(String orderId, OrderStatus status);
  Future<int> deleteOrder(String id);

  // Order Items
  Future<List<OrderItem>> getOrderItems(String orderId);
  Future<String> insertOrderItem(OrderItem item);
  Future<int> updateOrderItem(OrderItem item);
  Future<int> deleteOrderItem(String id);
  
  // Tables
  Future<List<RestaurantTable>> getTables();
  Future<RestaurantTable?> getTableById(String id);
  Future<String> addTable(RestaurantTable table);
  Future<int> updateTable(RestaurantTable table);
  Future<int> deleteTable(String id);

  // Token management
  Future<void> setToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> setRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();
} 