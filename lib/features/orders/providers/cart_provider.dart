import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/order_item.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/order.dart';
import 'package:uuid/uuid.dart';

class CartNotifier extends Notifier<List<OrderItem>> {
  final _uuid = Uuid();

  @override
  List<OrderItem> build() {
    return [];
  }

  void addItem(Product product, int quantity) {
    // Check if product already exists in cart
    final existingItemIndex = state.indexWhere(
      (item) => item.productId == product.id
    );

    if (existingItemIndex >= 0) {
      // Update existing item quantity
      final existingItem = state[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        totalPrice: (existingItem.quantity + quantity) * existingItem.unitPrice
      );
      
      state = [
        ...state.sublist(0, existingItemIndex),
        updatedItem,
        ...state.sublist(existingItemIndex + 1)
      ];
    } else {
      // Add new item
      state = [
        ...state,
        OrderItem(
          id: _uuid.v4(),
          productId: product.id,
          productName: product.name,
          quantity: quantity,
          unitPrice: product.price,
          totalPrice: product.price * quantity,
        )
      ];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final itemIndex = state.indexWhere((item) => item.productId == productId);
    if (itemIndex >= 0) {
      final item = state[itemIndex];
      final updatedItem = item.copyWith(
        quantity: quantity,
        totalPrice: quantity * item.unitPrice
      );

      state = [
        ...state.sublist(0, itemIndex),
        updatedItem,
        ...state.sublist(itemIndex + 1)
      ];
    }
  }

  // Load cart items from an existing order
  void loadCartFromOrder(Order order) {
    state = [...order.items];
  }

  void clearCart() {
    state = [];
  }

  double getTotal() {
    return state.fold(0, (total, item) => total + item.totalPrice);
  }

  int getItemCount() {
    return state.fold(0, (count, item) => count + item.quantity);
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<OrderItem>>(
  () => CartNotifier(),
); 