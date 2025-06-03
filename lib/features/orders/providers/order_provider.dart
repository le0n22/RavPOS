import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/order.dart';
import '../../../shared/models/order_status.dart';
import '../../../shared/models/table_status.dart';
import '../../../shared/models/table.dart';
import '../../../core/database/repositories/order_repository.dart';
import '../../../core/database/repositories/table_repository.dart';
import '../../tables/providers/table_provider.dart';
import '../../reports/presentation/printer_utils.dart';
import '../../reports/providers/printer_settings_provider.dart';
import '../../reports/providers/receipt_template_provider.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart' as esc_utils;
import 'package:esc_pos_printer/esc_pos_printer.dart' as pos_printer;
import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../shared/models/order_item.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return OrderRepository(apiService);
});

class OrderNotifier extends AsyncNotifier<List<Order>> {
  late final OrderRepository _repository;
  bool _isInitialized = false;
  List<Order> _cachedOrders = [];
  Order? _selectedOrder;

  Order? get selectedOrder => _selectedOrder;

  @override
  Future<List<Order>> build() async {
    _repository = ref.read(orderRepositoryProvider);
    return loadOrders();
  }

  void selectOrder(Order order) {
    _selectedOrder = order;
    ref.notifyListeners();
  }

  Future<List<Order>> loadOrders() async {
    try {
      state = const AsyncLoading();
      final orders = await _repository.getAllOrders();
      if (orders.isNotEmpty || _isInitialized) {
        _cachedOrders = orders;
        _isInitialized = true;
      }
      state = AsyncData(_cachedOrders);
      return _cachedOrders;
    } catch (e, stack) {
      print('Error loading orders: $e');
      state = AsyncError(e, stack);
      return [];
    }
  }

  Future<List<Order>> loadOrdersByStatus(OrderStatus status) async {
    state = const AsyncLoading();
    try {
      final orders = await _repository.getOrdersByStatus(status);
      state = AsyncData(orders);
      return orders;
    } catch (e, stack) {
      print('Error loading orders by status: $e');
      state = AsyncError(e, stack);
      return [];
    }
  }

  // Belirli bir masa için siparişleri getir (sadece tableId ile)
  Future<List<Order>> getOrdersByTable(String tableId) async {
    try {
      // Sadece tableId ile sorgulama yap
      final orders = await _repository.getOrdersByTable(tableId);
      return orders;
    } catch (e) {
      print('Error getting orders by table: $e');
      return [];
    }
  }

  // Get order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      // Check if order is in cache
      final cachedOrder = _cachedOrders.where((order) => order.id == orderId).firstOrNull;
      if (cachedOrder != null) {
        if (cachedOrder.items.isEmpty && cachedOrder.id.isNotEmpty) {
          final items = await _repository.getOrderItems(cachedOrder.id);
          return cachedOrder.copyWith(items: items);
        }
        return cachedOrder;
      }
      // Otherwise fetch from repository (ürünlerle birlikte)
      return await _repository.getOrderById(orderId);
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }

  // Generate next sequential order number
  Future<String> generateOrderNumber() async {
    try {
      final allOrders = await _repository.getAllOrders();
      int maxNumber = 0;
      for (final order in allOrders) {
        final orderNumber = order.orderNumber;
        final numericPart = orderNumber.replaceAll(RegExp(r'[^0-9]'), '');
        if (numericPart.isNotEmpty) {
          final number = int.tryParse(numericPart) ?? 0;
          if (number > maxNumber) {
            maxNumber = number;
          }
        }
      }
      final nextNumber = maxNumber + 1;
      return '#${nextNumber.toString().padLeft(3, '0')}';
    } catch (e) {
      print('Error generating order number: $e');
      return '#${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    }
  }

  // Sipariş oluştururken hem tableId hem tableNumber alanını doğru ata
  Future<String?> createOrder(Order order, {BuildContext? context}) async {
    try {
      print('[ORDER_PROVIDER_DEBUG] ===== Sipariş Oluşturma Başladı =====');
      
      print('[ORDER_PROVIDER_DEBUG] Gelen Sipariş Bilgileri:');
      print('[ORDER_PROVIDER_DEBUG] ${order.toJson()}');
      
      String tableId = order.tableId ?? order.tableNumber ?? '';
      if (tableId.isEmpty) {
        final tableRepo = ref.read(tableRepositoryProvider);
        RestaurantTable? takeoutTable;
        try {
          takeoutTable = await tableRepo.getTableByName('Takeout');
        } catch (_) {}
        if (takeoutTable == null) {
          takeoutTable = RestaurantTable(
            id: 'takeout',
            name: 'Takeout',
            capacity: 99,
            status: TableStatus.available,
            xPosition: 0.0,
            yPosition: 0.0,
            createdAt: DateTime.now(),
            category: 'Takeout',
          );
          await tableRepo.addTable(takeoutTable);
        }
        tableId = takeoutTable.id;
      }
      
      print('[ORDER_PROVIDER_DEBUG] Kullanılacak Masa ID: $tableId');
      
      // tableId ve tableNumber aynı id olacak şekilde ata
      final orderWithTable = order.copyWith(tableNumber: tableId, tableId: tableId);
      
      print('[ORDER_PROVIDER_DEBUG] Güncellenmiş Sipariş Bilgileri:');
      print('[ORDER_PROVIDER_DEBUG] ${orderWithTable.toJson()}');
      
      print('[ORDER_PROVIDER_DEBUG] Sipariş Kalemleri:');
      orderWithTable.items.forEach((item) {
        print('[ORDER_PROVIDER_DEBUG]   - Ürün: ${item.productName}');
        print('[ORDER_PROVIDER_DEBUG]     Miktar: ${item.quantity}');
        print('[ORDER_PROVIDER_DEBUG]     Birim Fiyat: ${item.unitPrice}');
        print('[ORDER_PROVIDER_DEBUG]     Toplam Fiyat: ${item.totalPrice}');
        print('[ORDER_PROVIDER_DEBUG]     Ürün ID: ${item.productId}');
      });
      
      final Order? createdOrder = await _repository.insertOrder(orderWithTable, orderWithTable.items);
      
      if (createdOrder != null && createdOrder.id.isNotEmpty) {
        // Append new order to existing state with isNew flag
        state = AsyncData([
          ...state.value!.where((o) => o.id != createdOrder?.id),
          createdOrder,
        ]);
        
        if (tableId.isNotEmpty) {
          try {
            await ref.read(tableProvider.notifier).updateTableStatus(
              tableId, 
              TableStatus.occupied,
              currentOrderId: createdOrder.id
            );
            
            print('[ORDER_PROVIDER_DEBUG] Masa Durumu Güncellendi');
          } catch (e) {
            print('[ORDER_PROVIDER_DEBUG] Masa Durumu Güncelleme Hatası: $e');
          }
        }
        
        // --- YENİ: Mutfak fişi otomatik yazdır ---
        try {
          final printers = ref.read(printerSettingsProvider);
          PrinterSettings? kitchenPrinter;
          if (printers.isNotEmpty) {
            kitchenPrinter = printers.firstWhere(
              (p) => p.type == PrinterType.kitchen,
              orElse: () => printers.first,
            );
          } else {
            kitchenPrinter = null;
          }
          
          print('[ORDER_PROVIDER_DEBUG] Mutfak Yazıcısı Bilgileri:');
          print('[ORDER_PROVIDER_DEBUG]   - Yazıcı Mevcut: ${kitchenPrinter != null}');
          
          if (kitchenPrinter != null) {
            final mappings = ref.read(printerTemplateMappingsProvider);
            final templates = ref.read(receiptTemplatesProvider);
            PrinterTemplateMapping? mapping;
            try {
              mapping = mappings.firstWhere((m) => m.printerName == kitchenPrinter!.name);
            } catch (_) {
              mapping = null;
            }
            
            print('[ORDER_PROVIDER_DEBUG]   - Eşleşen Şablon Bulundu: ${mapping != null}');
            
            if (mapping != null) {
              ReceiptTemplate? template;
              try {
                template = templates.firstWhere((t) => t.id == mapping!.templateId);
              } catch (_) {
                template = null;
              }
              
              print('[ORDER_PROVIDER_DEBUG]   - Şablon Bulundu: ${template != null}');
              
                // TODO: Implement or import printKitchenReceipt for kitchen printing
                // await printKitchenReceipt(
                //   orderWithTable,
                //   kitchenPrinter,
                //   template,
                //   context: context,
                // );
            }
          }
        } catch (e) {
          print('[ORDER_PROVIDER_DEBUG] Mutfak Yazdırma Hatası: $e');
        }
      }
      
      print('[ORDER_PROVIDER_DEBUG] ===== Sipariş Oluşturma Tamamlandı =====');
      
      return createdOrder?.id;
    } catch (e, stackTrace) {
      print('[ORDER_PROVIDER_DEBUG] Sipariş Oluşturma Hatası: $e');
      print('[ORDER_PROVIDER_DEBUG] Hata Detayları: $stackTrace');
      return null;
    }
  }

  // Update an order
  Future<bool> updateOrder(Order order) async {
    try {
      final result = await _repository.updateOrder(order);
      if (result) {
        _cachedOrders = await _repository.getAllOrders();
        state = AsyncData(_cachedOrders);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating order: $e');
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final result = await _repository.updateOrderStatus(orderId, status);
      if (result) {
        _cachedOrders = await _repository.getAllOrders();
        state = AsyncData(_cachedOrders);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  // Delete an order
  Future<bool> deleteOrder(String orderId) async {
    try {
      final result = await _repository.deleteOrder(orderId);
      if (result) {
        _cachedOrders = await _repository.getAllOrders();
        state = AsyncData(_cachedOrders);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting order: $e');
      return false;
    }
  }

  // Force refresh all data and clear cache
  Future<List<Order>> forceRefresh() async {
    _isInitialized = false;
    return loadOrders();
  }

  // Migrate all unlinked orders to the Takeout table
  Future<bool> migrateUnlinkedOrdersToTakeout() async {
    try {
      final allOrders = await _repository.getAllOrders();
      final unlinkedOrders = allOrders.where((order) => order.tableNumber == null || order.tableNumber!.isEmpty).toList();
      if (unlinkedOrders.isEmpty) return false;
      // Ensure Takeout table exists
      final tableRepo = TableRepository(ref.read(apiServiceProvider));
      RestaurantTable? takeoutTable;
      try {
        takeoutTable = await tableRepo.getTableByName('Takeout');
      } catch (_) {}
      if (takeoutTable == null) {
        takeoutTable = RestaurantTable(
          id: 'takeout',
          name: 'Takeout',
          capacity: 99,
          status: TableStatus.available,
          xPosition: 0.0,
          yPosition: 0.0,
          createdAt: DateTime.now(),
          category: 'Takeout',
        );
        await tableRepo.addTable(takeoutTable);
      }
      // Update all unlinked orders
      for (final order in unlinkedOrders) {
        final updatedOrder = order.copyWith(tableNumber: takeoutTable.id);
        await _repository.updateOrder(updatedOrder);
      }
      // Refresh cache
      _cachedOrders = await _repository.getAllOrders();
      state = AsyncData(_cachedOrders);
      return true;
    } catch (e) {
      print('Error migrating unlinked orders: $e');
      return false;
    }
  }

  /// Localdeki order'ın id'sini backend'den dönen id ile günceller
  void updateOrderId({required String localId, required String backendId}) {
    final index = _cachedOrders.indexWhere((o) => o.id == localId);
    if (index != -1) {
      final order = _cachedOrders[index];
      _cachedOrders[index] = order.copyWith(id: backendId);
      state = AsyncData(_cachedOrders);
    }
  }

  /// Update existing order by sending full items list
  Future<bool> updateOrderItems(String orderId, List<OrderItem> items) async {
    try {
      final response = await ref.read(apiServiceProvider).put(
        '/orders/$orderId',
        data: {'items': items.map((e) => e.toJson()).toList()},
      );
      if (response.statusCode == 200) {
        _cachedOrders = await _repository.getAllOrders();
        state = AsyncData(_cachedOrders);
        return true;
      }
      return false;
    } catch (e) {
      print('[ORDER_PROVIDER_DEBUG] Error updating order items: $e');
      return false;
    }
  }

  /// Mark a new order as seen (remove isNew flag)
  void markAsSeen(String orderId) {
    state = AsyncData([
      for (final o in state.value!)
        o.id == orderId
          ? Order.fromJson({
              ...o.toJson(),
              'is_new': false,
            })
          : o
    ]);
  }
}

// Main orders provider
final orderProvider = AsyncNotifierProvider<OrderNotifier, List<Order>>(
  () => OrderNotifier(),
);

// Selected order provider
final selectedOrderProvider = Provider<Order?>((ref) {
  return ref.watch(orderProvider.notifier).selectedOrder;
}); 