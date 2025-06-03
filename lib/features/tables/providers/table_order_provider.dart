import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/models/order_item.dart';
import '../../../shared/models/order.dart';
import '../../../shared/models/order_status.dart';
import '../../../shared/models/product.dart';
import '../../orders/providers/order_provider.dart';
import '../providers/table_provider.dart';
import 'package:ravpos/shared/models/table_status.dart';
import '../../users/providers/user_provider.dart';

class TableOrderState {
  final List<OrderItem> draftOrders; // Yeni siparişler (henüz kaydedilmemiş)
  final List<Order> existingOrders; // Mevcut siparişler (kaydedilmiş)
  final bool isLoading;
  final String? error;

  const TableOrderState({
    this.draftOrders = const [],
    this.existingOrders = const [],
    this.isLoading = false,
    this.error,
  });

  TableOrderState copyWith({
    List<OrderItem>? draftOrders,
    List<Order>? existingOrders,
    bool? isLoading,
    String? error,
  }) {
    return TableOrderState(
      draftOrders: draftOrders ?? this.draftOrders,
      existingOrders: existingOrders ?? this.existingOrders,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  double get draftTotal => draftOrders.fold(0, (total, item) => total + item.totalPrice);
  
  int get draftItemCount => draftOrders.fold(0, (count, item) => count + item.quantity);
  
  double get existingOrdersTotal => existingOrders.fold(0, (total, order) => total + order.totalAmount);
}

class TableOrderNotifier extends StateNotifier<TableOrderState> {
  final String tableId;
  final Ref ref;
  final _uuid = const Uuid();

  TableOrderNotifier({
    required this.tableId,
    required this.ref,
  }) : super(const TableOrderState());

  // Load existing orders for this table
  Future<void> loadExistingOrders() async {
    // Reset existing orders and set loading
    state = state.copyWith(existingOrders: [], isLoading: true, error: null);
    
    try {
      final orderNotifier = ref.read(orderProvider.notifier);
      final orders = await orderNotifier.getOrdersByTable(tableId);
      
      // Filter orders that are not delivered or cancelled (active orders)
      final activeOrders = orders.where((order) => 
        order.status != OrderStatus.delivered && 
        order.status != OrderStatus.cancelled
      ).toList();
      // DEBUG: Loaded active orders IDs
      print('[DEBUG] loadExistingOrders for table $tableId: active order IDs = ${activeOrders.map((o) => o.id).join(", ")}');
      
      state = state.copyWith(
        existingOrders: activeOrders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Siparişler yüklenirken hata oluştu: $e',
        isLoading: false,
      );
    }
  }

  // Add product to draft orders
  void addToDraft(Product product, int quantity) {
    print('[DRAFT_DEBUG] ===== addToDraft Başladı =====');
    print('[DRAFT_DEBUG] Gelen Ürün Bilgileri:');
    print('[DRAFT_DEBUG]   - Ürün ID: ${product.id}');
    print('[DRAFT_DEBUG]   - Ürün Adı: ${product.name}');
    print('[DRAFT_DEBUG]   - Ürün Fiyatı: ${product.price}');
    print('[DRAFT_DEBUG]   - Miktar: $quantity');
    
    final draftOrders = List<OrderItem>.from(state.draftOrders);
    
    print('[DRAFT_DEBUG] Mevcut Taslak Sipariş Sayısı: ${draftOrders.length}');
    
    // Check if product already exists in draft
    final existingItemIndex = draftOrders.indexWhere(
      (item) => item.productId == product.id
    );

    if (existingItemIndex >= 0) {
      // Update existing item quantity
      final existingItem = draftOrders[existingItemIndex];
      final newQuantity = existingItem.quantity + quantity;
      final newTotalPrice = newQuantity * existingItem.unitPrice;
      
      print('[DRAFT_DEBUG] Mevcut Ürün Güncelleniyor:');
      print('[DRAFT_DEBUG]   - Eski Miktar: ${existingItem.quantity}');
      print('[DRAFT_DEBUG]   - Yeni Miktar: $newQuantity');
      print('[DRAFT_DEBUG]   - Eski Toplam Fiyat: ${existingItem.totalPrice}');
      print('[DRAFT_DEBUG]   - Yeni Toplam Fiyat: $newTotalPrice');
      
      draftOrders[existingItemIndex] = existingItem.copyWith(
        quantity: newQuantity,
        totalPrice: newTotalPrice
      );
    } else {
      // Add new item
      final totalPrice = product.price * quantity;
      
      print('[DRAFT_DEBUG] Yeni Ürün Ekleniyor:');
      print('[DRAFT_DEBUG]   - Toplam Fiyat: $totalPrice');
      
      draftOrders.add(OrderItem(
        id: _uuid.v4(),
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        unitPrice: product.price,
        totalPrice: totalPrice,
      ));
    }

    print('[DRAFT_DEBUG] Güncellenmiş Taslak Sipariş Sayısı: ${draftOrders.length}');
    state = state.copyWith(draftOrders: draftOrders);
    
    print('[DRAFT_DEBUG] Toplam Taslak Sipariş Tutarı: ${state.draftTotal}');
    
    // Log all draft order items
    print('[DRAFT_DEBUG] Tüm Taslak Sipariş Kalemleri:');
    state.draftOrders.forEach((item) {
      print('[DRAFT_DEBUG]   - Ürün: ${item.productName}');
      print('[DRAFT_DEBUG]     Miktar: ${item.quantity}');
      print('[DRAFT_DEBUG]     Birim Fiyat: ${item.unitPrice}');
      print('[DRAFT_DEBUG]     Toplam Fiyat: ${item.totalPrice}');
    });
    
    print('[DRAFT_DEBUG] ===== addToDraft Tamamlandı =====');
  }

  // Remove item from draft orders
  void removeFromDraft(String productId) {
    final draftOrders = state.draftOrders
        .where((item) => item.productId != productId)
        .toList();
    
    state = state.copyWith(draftOrders: draftOrders);
  }

  // Update quantity in draft orders
  void updateDraftQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromDraft(productId);
      return;
    }

    final draftOrders = List<OrderItem>.from(state.draftOrders);
    final itemIndex = draftOrders.indexWhere((item) => item.productId == productId);
    
    if (itemIndex >= 0) {
      final item = draftOrders[itemIndex];
      draftOrders[itemIndex] = item.copyWith(
        quantity: quantity,
        totalPrice: quantity * item.unitPrice
      );

      state = state.copyWith(draftOrders: draftOrders);
    }
  }

  // Clear draft orders
  void clearDraft() {
    state = state.copyWith(draftOrders: []);
  }

  // Save draft orders - either create new or update existing order
  Future<bool> saveDraftOrder() async {
    print('[SAVE_ORDER_TRACE] Called saveDraftOrder. Draft items count: ${state.draftOrders.length}');
    if (state.draftOrders.isEmpty) {
      print('[SAVE_ORDER_TRACE] Draft is empty, returning false.');
      return false; // Nothing to save
    }

    state = state.copyWith(isLoading: true, error: null);
    print('[SAVE_ORDER_TRACE] isLoading set to true.');

    try {
      final orderNotifier = ref.read(orderProvider.notifier);
      final draftItems = List<OrderItem>.from(state.draftOrders); // Create a copy for safety
      final currentDraftTotal = draftItems.fold(0.0, (sum, item) => sum + item.totalPrice);
      print('[SAVE_ORDER_TRACE] Copied draftItems. Count: ${draftItems.length}, Calculated Draft Total: $currentDraftTotal');

      // Check if there is already an active "pending" order for this table
      final existingPendingOrder = state.existingOrders.firstWhere(
        (order) => order.status == OrderStatus.pending,
        orElse: () {
          print('[SAVE_ORDER_TRACE] No existing pending order found (orElse triggered).');
          return Order.empty; // Placeholder empty order
        },
      );
      print('[SAVE_ORDER_TRACE] Checked for existing pending order. Found Order ID: ${existingPendingOrder.id.isEmpty ? "None (Order.empty)" : existingPendingOrder.id}, Status: ${existingPendingOrder.status}');

      bool success = false;

      if (existingPendingOrder.id.isNotEmpty && existingPendingOrder.id != Order.empty.id) { // Double check it's not the empty placeholder
        // --- UPDATE EXISTING ORDER ---
        print('[SAVE_ORDER_TRACE] Attempting to UPDATE existing order ID: ${existingPendingOrder.id} with ${draftItems.length} new items.');
        success = await orderNotifier.updateOrderItems(
          existingPendingOrder.id,
          draftItems,
        );
        print('[SAVE_ORDER_TRACE] Update existing order call result: $success');

      } else {
        // --- CREATE NEW ORDER ---
        print('[SAVE_ORDER_TRACE] No valid pending order found. Attempting to CREATE NEW order.');
        final currentUser = ref.read(currentUserProvider);
        if (currentUser == null) {
          print('[SAVE_ORDER_TRACE] User not found for new order. Returning false.');
          state = state.copyWith(error: 'User not found.', isLoading: false);
          return false;
        }

        final newOrderPayload = Order(
          id: const Uuid().v4(),
          orderNumber: await orderNotifier.generateOrderNumber(),
          tableId: tableId,
          userId: currentUser.id,
          items: draftItems, // Use the copied draft items
          status: OrderStatus.pending,
          totalAmount: currentDraftTotal, // Use the calculated draft total
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        print('[SAVE_ORDER_TRACE] New order payload created. Order Number: ${newOrderPayload.orderNumber}, Items Count: ${newOrderPayload.items.length}, Total: ${newOrderPayload.totalAmount}');

        final savedBackendOrderId = await orderNotifier.createOrder(newOrderPayload);
        success = savedBackendOrderId != null && savedBackendOrderId.isNotEmpty;
        print('[SAVE_ORDER_TRACE] Create new order call result: $success, Backend Order ID: $savedBackendOrderId');
      }

      if (success) {
        print('[SAVE_ORDER_TRACE] Order operation successful. Clearing draft and reloading existing orders.');
        state = state.copyWith(draftOrders: []); // Clear draft
        await loadExistingOrders();              // Then reload existing orders
        ref.invalidate(tableProvider);           // Invalidate main tables list provider
        state = state.copyWith(isLoading: false, error: null);
        print('[SAVE_ORDER_TRACE] State updated after success. isLoading: false.');
        return true;
      } else {
        print('[SAVE_ORDER_TRACE] Order operation FAILED. Error might have been set by called function or will be set now.');
        // Ensure an error message is set if success is false but no error was thrown previously
        final currentError = state.error;
        state = state.copyWith(error: currentError ?? 'Failed to save the order.', isLoading: false);
        return false;
      }

    } catch (e, stackTrace) {
      print('[SAVE_ORDER_TRACE] Exception caught in saveDraftOrder: $e');
      print('[SAVE_ORDER_TRACE] StackTrace: $stackTrace');
      state = state.copyWith(error: 'An error occurred: $e', isLoading: false);
      return false;
    }
  }

  // Update order status (for existing orders)
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await ref.read(orderProvider.notifier).updateOrderStatus(orderId, status);
      
      // Reload existing orders to reflect the change
      await loadExistingOrders();
      
    } catch (e) {
      state = state.copyWith(
        error: 'Sipariş durumu güncellenirken hata oluştu: $e',
        isLoading: false,
      );
    }
  }

  Future<void> completeOrder() async {
    try {
      // Get the current pending order
      final pendingOrder = state.existingOrders.where(
        (order) => order.status == OrderStatus.pending
      ).firstOrNull;
      
      if (pendingOrder == null) return;
      
      // Update order status to delivered
      await ref.read(orderProvider.notifier).updateOrderStatus(
        pendingOrder.id,
        OrderStatus.delivered,
      );
      
      // Reload existing orders
      await loadExistingOrders();
      
    } catch (e) {
      state = state.copyWith(
        error: 'Sipariş tamamlanırken hata oluştu: $e',
        isLoading: false,
      );
    }
  }
}

// Provider for a specific table's orders
final tableOrderProvider = StateNotifierProvider.family<TableOrderNotifier, TableOrderState, String>(
  (ref, tableId) => TableOrderNotifier(tableId: tableId, ref: ref),
); 