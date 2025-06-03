import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/database/repositories/order_repository.dart';
import '../../../shared/models/models.dart';
import '../../../features/tables/providers/table_provider.dart';
import '../../../core/printer/printer.dart';
import '../../../core/printer/printer_service.dart';
import '../../../shared/providers/providers.dart';

part 'payment_provider.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const PaymentState._();  // Add this line to allow custom methods
  
  const factory PaymentState({
    required Order orderToProcess, // Ödenecek sipariş
    @Default(0.0) double amountReceived, // Müşteriden alınan tutar
    @Default(0.0) double changeDue, // Para üstü
    @Default(0.0) double discountApplied, // Uygulanan indirim tutarı
    @Default('') String discountCode, // İndirim kodu
    @Default(PaymentMethod.cash) PaymentMethod selectedPaymentMethod, // Seçilen ödeme yöntemi
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool printingError,
  }) = _PaymentState;
}

class PaymentNotifier extends Notifier<PaymentState> {
  late final OrderRepository _orderRepository;

  @override
  PaymentState build() {
    _orderRepository = ref.read(orderRepositoryProvider);
    // Başlangıçta boş bir sipariş oluştur, daha sonra initialize ile değiştirilecek
    // Gerçek kullanımda bu constructor çağrılmadan önce initialize edilmelidir
    return PaymentState(
      orderToProcess: Order(
        id: '',
        orderNumber: '',
        tableNumber: '',
        tableId: '',
        items: [],
        status: OrderStatus.pending,
        totalAmount: 0.0,
        createdAt: DateTime.now(),
        userId: null,
        discountAmount: null,
        paymentMethod: null,
        metadata: null,
      ),
    );
  }

  // Ödeme işlemini başlatır
  void initialize(Order order) {
    state = PaymentState(
      orderToProcess: order,
      amountReceived: 0.0,
      changeDue: 0.0,
      discountApplied: order.discountAmount ?? 0.0,  // Varsa mevcut indirim tutarını al
      discountCode: '',
      selectedPaymentMethod: order.paymentMethod ?? PaymentMethod.cash,  // Varsa mevcut ödeme yöntemini al
      isLoading: false,
      errorMessage: null,
      printingError: false,
    );
  }

  // Müşteriden alınan tutarı günceller ve para üstünü hesaplar
  void updateAmountReceived(double amount) {
    if (amount < 0) return;
    state = state.copyWith(
      amountReceived: amount,
      changeDue: calculateChangeDue(amount),
    );
  }

  // İndirim tutarını uygular
  void applyDiscount(double amount) {
    if (amount < 0 || amount > state.orderToProcess.totalAmount) {
      state = state.copyWith(
        errorMessage: 'Geçersiz indirim tutarı',
      );
      return;
    }
    
    state = state.copyWith(
      discountApplied: amount,
      changeDue: calculateChangeDue(state.amountReceived),
      errorMessage: null,
    );
  }

  // İndirim kodunu uygular
  void applyDiscountByCode(String code) {
    // Örnek bir indirim kodu işlemi
    if (code.isEmpty) return;
    
    double discountAmount = 0.0;
    
    // Basit bir örnek: "IND10" kodu %10 indirim yapar
    if (code == "IND10") {
      discountAmount = state.orderToProcess.totalAmount * 0.1;
    } else if (code == "IND20") {
      discountAmount = state.orderToProcess.totalAmount * 0.2;
    } else if (code == "IND50") {
      discountAmount = state.orderToProcess.totalAmount * 0.5;
    } else {
      state = state.copyWith(
        errorMessage: 'Geçersiz indirim kodu',
      );
      return;
    }
    
    state = state.copyWith(
      discountCode: code,
      discountApplied: discountAmount,
      changeDue: calculateChangeDue(state.amountReceived),
      errorMessage: null,
    );
  }

  // Ödeme yöntemini seçer
  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(
      selectedPaymentMethod: method, 
      errorMessage: null
    );
  }

  // Validate and apply discount code
  Future<void> applyDiscountCode(String code) async {
    try {
      // TODO: Implement actual discount code validation logic
      // This is a placeholder implementation
      if (code.isEmpty) {
        state = state.copyWith(
          errorMessage: 'İndirim kodu boş olamaz',
          discountCode: '',
        );
        return;
      }

      // Simulated discount validation
      if (code == 'RAVPOS10') {
        final discountAmount = state.orderToProcess.totalAmount * 0.1; // 10% discount
        state = state.copyWith(
          discountCode: code,
          discountApplied: discountAmount,
          changeDue: calculateChangeDue(state.amountReceived),
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          errorMessage: 'Geçersiz indirim kodu',
          discountCode: '',
        );
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'İndirim kodu işlenirken hata oluştu: $e',
        discountCode: '',
      );
    }
  }

  // Hesaplanan para üstünü hesaplar
  double calculateChangeDue(double amountReceived) {
    final totalAmount = state.orderToProcess.totalAmount - state.discountApplied;
    return amountReceived > totalAmount 
      ? amountReceived - totalAmount 
      : 0.0;
  }

  // Ödeme yöntemini değiştirir
  void changePaymentMethod(PaymentMethod method) {
    state = state.copyWith(
      selectedPaymentMethod: method,
    );
  }

  // Ödeme işlemini tamamlar
  Future<void> processPayment() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // Validate payment amount
      final totalAmount = state.orderToProcess.totalAmount - state.discountApplied;
      
      if (state.selectedPaymentMethod == PaymentMethod.cash && state.amountReceived < totalAmount) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Ödenen tutar yetersiz. Toplam tutar: $totalAmount TL',
        );
        return;
      }
      
      // For card payments, we don't need to validate the amount received
      if (state.selectedPaymentMethod == PaymentMethod.card) {
        // For card payments, set the amount received to the total amount
        state = state.copyWith(amountReceived: totalAmount);
      }
      
      // Check if this is a combined order with multiple original orders
      final orderIds = state.orderToProcess.metadata?['originalOrderIds'] as List<dynamic>?;
      
      if (orderIds != null && orderIds.isNotEmpty) {
        // Update all original orders to delivered status
        for (final orderId in orderIds) {
          final originalOrder = await _orderRepository.getOrderById(orderId.toString());
          if (originalOrder != null) {
            final updatedOrder = originalOrder.copyWith(
              status: OrderStatus.delivered,
              paymentMethod: state.selectedPaymentMethod,
              updatedAt: DateTime.now(),
            );
            
            await _orderRepository.updateOrder(updatedOrder);
          }
        }
      } else {
        // Process single order
        // First update order status to done
        final completedOrder = state.orderToProcess.copyWith(
          status: OrderStatus.delivered,
          paymentMethod: state.selectedPaymentMethod,
          discountAmount: state.discountApplied,
          updatedAt: DateTime.now(),
        );
        
        final updateResult = await _orderRepository.updateOrder(completedOrder);
        
        if (updateResult <= 0) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Sipariş güncellenemedi',
          );
          return;
        }
      }

      // If the order has a table number, update table status to available
      if (state.orderToProcess.tableNumber != null) {
        try {
          final tables = await ref.read(tableProvider.notifier).loadTables();
          
          // Try to find table by name or ID
          final tableToUpdate = tables.where((t) => 
            t.name == state.orderToProcess.tableNumber || 
            t.id == state.orderToProcess.tableNumber
          ).firstOrNull;
          
          if (tableToUpdate != null) {
            await ref.read(tableProvider.notifier).updateTableStatus(
              tableToUpdate.id,
              TableStatus.available, // Önemli: Masa durumunu available olarak güncelle
              currentOrderId: null
            );
          } else {
            
            // Yine de masa ismi ile aramayı deneyelim (alternatif çözüm)
            for (final table in tables) {
              if (table.name == state.orderToProcess.tableNumber) {
                await ref.read(tableProvider.notifier).updateTableStatus(
                  table.id,
                  TableStatus.available,
                  currentOrderId: null
                );
                break;
              }
            }
          }
        } catch (e) {
          // Continue with payment completion even if table update fails
        }
      }

      // Try to print receipt
      try {
        final printerService = PrinterService();
        await printerService.loadSettings(); // Load saved settings
        
        if (printerService.isConnected) {
          await printerService.printReceipt(state.orderToProcess);
        }
      } catch (e) {
        state = state.copyWith(
          printingError: true,
        );
        // Don't set error message here to avoid blocking payment completion
      }

      // Reset state after successful payment
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        amountReceived: 0.0,
        changeDue: 0.0,
        discountApplied: 0.0,
        discountCode: '',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ödeme işlemi sırasında hata oluştu: $e',
      );
    }
  }

  // Ödeme iptal edildiğinde çağrılır
  void cancelPayment() {
    state = state.copyWith(
      amountReceived: 0.0,
      changeDue: 0.0,
      discountApplied: 0.0,
      discountCode: '',
      errorMessage: null,
      isLoading: false,
    );
  }
}

// Provider tanımı
final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  () => PaymentNotifier(),
); 