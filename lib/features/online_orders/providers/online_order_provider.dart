import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:ravpos/core/database/repositories/order_repository.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:ravpos/features/products/providers/product_provider.dart';
import 'package:ravpos/shared/providers/providers.dart';

class OnlineOrderNotifier extends AsyncNotifier<List<OnlineOrder>> {
  late final OrderRepository _repository;
  
  @override
  Future<List<OnlineOrder>> build() async {
    _repository = ref.read(orderRepositoryProvider);
    // Initialize with empty list
    return [];
  }
  
  // Simulate fetching online orders
  Future<void> fetchOnlineOrders() async {
    state = const AsyncLoading();
    try {
      final orders = await _repository.fetchOnlineOrders();
      state = AsyncData(orders);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
  
  // Accept an online order
  Future<void> acceptOnlineOrder(String onlineOrderId) async {
    try {
      await _repository.acceptOnlineOrder(onlineOrderId);
      await fetchOnlineOrders();
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
  
  // Reject an online order
  Future<void> rejectOnlineOrder(String onlineOrderId, String reason) async {
    try {
      await _repository.rejectOnlineOrder(onlineOrderId, reason);
      await fetchOnlineOrders();
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
  
  // Helper method to simulate new online orders
  Future<List<OnlineOrder>> _simulateNewOrders(int count) async {
    const uuid = Uuid();
    final random = Random();
    
    // Get products from product provider to create realistic orders
    final productsAsync = await ref.read(productProvider.future);
    final products = productsAsync.isNotEmpty ? productsAsync : [];
    if (products.isEmpty) {
      throw Exception('No products available to create orders');
    }
    
    // Generate random orders
    return List.generate(count, (index) {
      // Pick a random platform
      final platform = OnlinePlatform.values[random.nextInt(OnlinePlatform.values.length)];
      
      // Generate between 1-5 random items
      final itemCount = 1 + random.nextInt(4);
      final items = List.generate(itemCount, (_) {
        // Pick a random product
        final product = products[random.nextInt(products.length)];
        // Random quantity between 1-3
        final quantity = 1 + random.nextInt(3);
        
        // Create order item
        return OrderItem(
          id: uuid.v4(),
          productId: product.id,
          productName: product.name,
          quantity: quantity,
          unitPrice: product.price,
          totalPrice: product.price * quantity,
          specialInstructions: random.nextBool() ? 'Özel istek ${random.nextInt(100)}' : null,
        );
      });
      
      // Calculate total
      final totalAmount = items.fold(0.0, (sum, item) => sum + item.totalPrice);
      
      // Create online order
      return OnlineOrder(
        onlineOrderId: '${platform.name.substring(0, 3).toUpperCase()}${100 + random.nextInt(900)}',
        platform: platform,
        customerName: 'Müşteri ${100 + random.nextInt(900)}',
        customerPhone: '05${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}${random.nextInt(10)}',
        customerAddress: random.nextBool() ? 'Adres ${random.nextInt(100)}, Sokak ${random.nextInt(50)}, Daire ${random.nextInt(20)}' : null,
        items: items,
        totalAmount: totalAmount,
        createdAt: DateTime.now().subtract(Duration(minutes: random.nextInt(60))),
        customerNote: random.nextBool() ? 'Lütfen hızlı gönderin, acelem var.' : null,
      );
    });
  }
  
  // Convert online order to regular POS order
  Future<void> _convertToRegularOrder(OnlineOrder onlineOrder) async {
    const uuid = Uuid();
    
    // Create a new Order
    final newOrder = Order(
      id: uuid.v4(),
      orderNumber: 'ONL-${onlineOrder.platform.name.substring(0, 3).toUpperCase()}-${onlineOrder.onlineOrderId}',
      tableNumber: 'ONLINE', // Use table ID for online orders
      tableId: 'ONLINE',     // Set tableId field
      items: onlineOrder.items,
      status: OrderStatus.pending,
      totalAmount: onlineOrder.totalAmount,
      createdAt: DateTime.now(),
      customerNote: 'Online Sipariş - ${onlineOrder.platform.displayName}\n'
          'Müşteri: ${onlineOrder.customerName}\n'
          'Tel: ${onlineOrder.customerPhone}\n'
          '${onlineOrder.customerAddress != null ? 'Adres: ${onlineOrder.customerAddress}\n' : ''}'
          '${onlineOrder.customerNote != null ? 'Not: ${onlineOrder.customerNote}' : ''}',
      userId: null,
      discountAmount: null,
      paymentMethod: null,
      metadata: null,
    );
    
    // Add to order provider
    await ref.read(orderProvider.notifier).createOrder(newOrder);
    
    // TODO: Print kitchen ticket if needed
    // ref.read(printerServiceProvider).printKitchenTicket(newOrder);
  }
}

// Provider for online orders
final onlineOrderProvider = AsyncNotifierProvider<OnlineOrderNotifier, List<OnlineOrder>>(() {
  return OnlineOrderNotifier();
}); 