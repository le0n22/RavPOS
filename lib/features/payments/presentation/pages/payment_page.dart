import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ravpos/shared/providers/providers.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:ravpos/features/payments/providers/payment_provider.dart';
import 'package:ravpos/features/reports/presentation/printer_utils.dart';
import 'package:ravpos/features/reports/providers/printer_settings_provider.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final String? orderId;
  final String? tableId;
  
  const PaymentPage({
    Key? key,
    this.orderId,
    this.tableId,
  }) : super(key: key);

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final _amountController = TextEditingController();
  final _discountController = TextEditingController();
  final _discountCodeController = TextEditingController();
  Order? _order;
  bool _initialized = false;
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    
    // Load order details when widget initializes
    _loadOrderDetails();
  }
  
  Future<void> _loadOrderDetails() async {
    try {
      print('[DEBUG] Payment Page Init: orderId=${widget.orderId}, tableId=${widget.tableId}');
      
      // If orderId is provided, fetch the order
      if (widget.orderId != null) {
        final orderRepository = ref.read(orderRepositoryProvider);
        final order = await orderRepository.getOrderById(widget.orderId!);
        
        if (order == null) {
          setState(() {
            _errorMessage = 'Sipariş bulunamadı';
            _isLoading = false;
          });
          return;
        }
        
        // Initialize payment state with the order
        ref.read(paymentProvider.notifier).initialize(order);
        
        setState(() {
          _order = order;
          _initialized = true;
          _isLoading = false;
        });
      } 
      // If tableId is provided, fetch all active orders for that table
      else if (widget.tableId != null) {
        print('[DEBUG] Attempting to load orders for tableId: ${widget.tableId}');
        final orderRepository = ref.read(orderRepositoryProvider);
        
        // Get all orders for this table
        final tableOrders = await orderRepository.getOrdersByTable(widget.tableId!);
        print('[DEBUG] Total orders for table: ${tableOrders.length}');
        print('[DEBUG] Order items: ${tableOrders.map((o) => '${o.id}: ${o.items.length} items, total: ${o.totalAmount}').join(', ')}');
        
        // Filter out delivered and cancelled orders
        final activeOrders = tableOrders.where((order) => 
          order.status != OrderStatus.delivered && 
          order.status != OrderStatus.cancelled
        ).toList();
        
        print('[DEBUG] Active orders for table: ${activeOrders.length}');
        print('[DEBUG] Active order details: ${activeOrders.map((o) => '${o.id}: ${o.items.length} items, ${o.items.map((i) => '${i.productName}x${i.quantity}').join('+')}').join('\n')}');
        
        if (activeOrders.isEmpty) {
          print('[DEBUG] No active order found for tableId: ${widget.tableId}');
          setState(() {
            _errorMessage = 'Aktif sipariş bulunamadı';
            _isLoading = false;
          });
          return;
        }
        
        // Combine all active orders into a single order for payment
        final combinedOrder = _combineOrders(activeOrders);
        print('[DEBUG] Combined order total: ${combinedOrder.totalAmount}, items: ${combinedOrder.items.length}');
        print('[DEBUG] Combined item details: ${combinedOrder.items.map((i) => '${i.productName}x${i.quantity}=${i.totalPrice}').join(', ')}');
        
        // Initialize payment state with the combined order
        ref.read(paymentProvider.notifier).initialize(combinedOrder);
        
        setState(() {
          _order = combinedOrder;
          _initialized = true;
          _isLoading = false;
        });
      } else {
        // No order or table identifier provided
        setState(() {
          _errorMessage = 'Sipariş veya masa bilgisi bulunamadı';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[ERROR] Error loading order details: $e');
      setState(() {
        _errorMessage = 'Sipariş yüklenirken hata oluştu: $e';
        _isLoading = false;
      });
    }
  }
  
  // Helper method to combine multiple orders into one for payment
  Order _combineOrders(List<Order> orders) {
    if (orders.isEmpty) {
      throw Exception('Cannot combine empty orders list');
    }
    
    // Use the most recent order as the base
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final baseOrder = orders.first;
    
    // Combine all items from all orders
    final allItems = <OrderItem>[];
    final combinedItemMap = <String, OrderItem>{};
    double totalAmount = 0.0;
    
    print('[DEBUG] Combining orders: ${orders.length} orders');
    
    // First combine all items while tracking totals properly
    for (final order in orders) {
      print('[DEBUG] Adding order ${order.id} with ${order.items.length} items, amount ${order.totalAmount} to combined order');
      
      for (final item in order.items) {
        final itemKey = '${item.productId}:${item.unitPrice}'; // Use product ID and price as a unique key
        
        if (combinedItemMap.containsKey(itemKey)) {
          // If this product already exists, just update quantity and total
          final existingItem = combinedItemMap[itemKey]!;
          final newQuantity = existingItem.quantity + item.quantity;
          final newTotalPrice = newQuantity * existingItem.unitPrice;
          
          combinedItemMap[itemKey] = existingItem.copyWith(
            quantity: newQuantity,
            totalPrice: newTotalPrice
          );
        } else {
          // Otherwise add as new item
          combinedItemMap[itemKey] = item;
        }
      }
    }
    
    // Convert map to list
    allItems.addAll(combinedItemMap.values);
    
    // Recalculate total
    totalAmount = allItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    
    print('[DEBUG] Combined order: ${allItems.length} unique items, total: $totalAmount');
    print('[DEBUG] Item breakdown: ${allItems.map((i) => '${i.productName}x${i.quantity}=${i.totalPrice}').join(', ')}');
    
    // Create a new combined order
    return Order(
      id: baseOrder.id,
      orderNumber: baseOrder.orderNumber,
      tableNumber: baseOrder.tableId,
      tableId: baseOrder.tableId,
      status: baseOrder.status,
      items: allItems,
      totalAmount: totalAmount, // Use calculated total
      createdAt: baseOrder.createdAt,
      updatedAt: DateTime.now(),
      customerNote: baseOrder.customerNote,
      metadata: {'originalOrderIds': orders.map((o) => o.id).toList()},
      userId: null,
      discountAmount: null,
      paymentMethod: null,
    );
  }
  
  void _processPayment() async {
    try {
      // Validate input
      final paymentState = ref.read(paymentProvider);
      final totalAmount = _order!.totalAmount - paymentState.discountApplied;
      
      // For cash payments, ensure amount is entered
      if (paymentState.selectedPaymentMethod == PaymentMethod.cash && 
          (paymentState.amountReceived <= 0 || _amountController.text.isEmpty)) {
        _showErrorDialog('Lütfen ödenen tutarı giriniz.');
        return;
      }
      
      // For cash payments, ensure amount is sufficient
      if (paymentState.selectedPaymentMethod == PaymentMethod.cash && 
          paymentState.amountReceived < totalAmount) {
        _showErrorDialog('Ödenen tutar yetersiz. Toplam tutar: ${totalAmount.toStringAsFixed(2)} TL');
        return;
      }
      
      // Show loading dialog
      _showLoadingDialog();
      
      // Process payment with timeout
      bool paymentCompleted = false;
      
      // Start a timeout timer
      Future.delayed(const Duration(seconds: 10), () {
        if (!paymentCompleted && mounted) {
          Navigator.of(context).pop(); // Close loading dialog if still showing
          _showErrorDialog('Ödeme işlemi zaman aşımına uğradı. Lütfen tekrar deneyin.');
        }
      });
      
      // Process payment
      await ref.read(paymentProvider.notifier).processPayment();
      
      paymentCompleted = true;
      
      // Hide loading dialog if it's still showing
      if (mounted) {
        // Check if dialog is showing before trying to close it
        Navigator.of(context, rootNavigator: true).popUntil((route) {
          return route.settings.name != null && 
                 !route.settings.name!.contains('Dialog');
        });
      }
      
      // Check for errors after payment processing
      final updatedState = ref.read(paymentProvider);
      if (updatedState.errorMessage != null) {
        if (mounted) {
          _showErrorDialog(updatedState.errorMessage!);
        }
        return;
      }
      
      // --- YENİ: Ödeme başarılıysa fiş yazdır ---
      final printers = ref.read(printerSettingsProvider);
      PrinterSettings? receiptPrinter;
      if (printers.isNotEmpty) {
        receiptPrinter = printers.firstWhere(
          (p) => p.type == PrinterType.receipt,
          orElse: () => printers.first,
        );
      } else {
        receiptPrinter = null;
      }
      if (receiptPrinter != null) {
        await printOrderWithTemplate(
          order: _order!,
          ref: ref,
          printerName: receiptPrinter.name,
          context: context,
        );
      }
      // --- SON ---

      // Show success dialog
      if (mounted) {
        await _showPaymentSuccessDialog();
        // Navigate back to tables page
        if (mounted) {
          context.go('/tables');
        }
      }
    } catch (e) {
      print('[ERROR] Payment processing error: $e');
      
      // Hide loading dialog if visible
      if (mounted) {
        // Check if dialog is showing before trying to close it
        Navigator.of(context, rootNavigator: true).popUntil((route) {
          return route.settings.name != null && 
                 !route.settings.name!.contains('Dialog');
        });
      }
      
      // Show error dialog
      if (mounted) {
        _showErrorDialog('Ödeme işlemi sırasında bir hata oluştu: $e');
      }
    }
  }
  
  Future<void> _showLoadingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Ödeme işleniyor...'),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _showPaymentSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ödeme Başarılı'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Sipariş başarıyla ödendi.'),
                Text('Fiş yazdırılıyor...'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Ödeme işlemi sırasında bir hata oluştu:'),
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Show loading indicator while loading
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ödeme'),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    // No order was loaded for the table
    if (_order == null) {
      return Scaffold(
        appBar: AppBar(
          title: widget.tableId != null 
              ? Text('Masa Ödemesi - ${widget.tableId}') 
              : const Text('Ödeme'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.orange,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Bu masada aktif sipariş bulunmamaktadır.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/tables'),
                child: const Text('Masalara Geri Dön'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final paymentState = ref.watch(paymentProvider);
    final isLoading = paymentState.isLoading;
    
    return Scaffold(
      appBar: AppBar(
        title: widget.tableId != null 
            ? Text('Masa Ödemesi - ${_order!.tableNumber ?? widget.tableId}') 
            : const Text('Ödeme'),
        centerTitle: true,
        actions: [
          if (widget.tableId != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Siparişe Geri Dön',
              onPressed: () => context.go('/tables'),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context, paymentState),
    );
  }
  
  Widget _buildBody(BuildContext context, PaymentState paymentState) {
    final theme = Theme.of(context);
    
    // Doğru tutarı göstermek için burada hesaplayalım
    final rawTotal = _order?.totalAmount ?? 0.0;
    final discount = paymentState.discountApplied;
    final finalTotal = rawTotal - discount;
    
    print('[PAYMENT_DEBUG] Display totals: Raw=${rawTotal.toStringAsFixed(2)}, ' +
          'Discount=${discount.toStringAsFixed(2)}, Final=${finalTotal.toStringAsFixed(2)}');
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Summary
          Expanded(
            flex: 3,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sipariş Özeti',
                          style: theme.textTheme.titleLarge,
                        ),
                        if (_order?.tableNumber != null)
                          Text(
                            'Masa: ${_order!.tableNumber}',
                            style: theme.textTheme.titleMedium,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Order metadata if this is a combined order
                    if (_order?.metadata != null && 
                        _order!.metadata!.containsKey('originalOrderIds'))
                      Text(
                        'Toplam ${(_order!.metadata!['originalOrderIds'] as List).length} sipariş',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const SizedBox(height: 16),
                    
                    // Order Items
                    Expanded(
                      child: _order?.items.isEmpty == true 
                        ? Center(
                            child: Text(
                              'Bu siparişte ürün bulunmamaktadır.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _order?.items.length ?? 0,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _order!.items[index];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  item.productName,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)} TL',
                                  style: theme.textTheme.bodySmall,
                                ),
                                trailing: Text(
                                  '${item.totalPrice.toStringAsFixed(2)} TL',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                    ),
                    
                    const Divider(),
                    
                    // Total Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Toplam',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          '${rawTotal.toStringAsFixed(2)} TL',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    // Discount Amount
                    if (discount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'İndirim',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            '- ${discount.toStringAsFixed(2)} TL',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      
                    // Final Amount
                    if (discount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ödenecek Tutar',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${finalTotal.toStringAsFixed(2)} TL',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Payment Methods and Input
          Expanded(
            flex: 2,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Ödeme Yöntemi',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    
                    // Payment Method Selection
                    ToggleButtons(
                      isSelected: [
                        paymentState.selectedPaymentMethod == PaymentMethod.cash,
                        paymentState.selectedPaymentMethod == PaymentMethod.card,
                      ],
                      onPressed: (index) {
                        ref.read(paymentProvider.notifier).changePaymentMethod(
                          index == 0 ? PaymentMethod.cash : PaymentMethod.card,
                        );
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Nakit'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Kart'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Amount Input
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Ödenen Tutar',
                        suffixText: 'TL',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        ref.read(paymentProvider.notifier).updateAmountReceived(amount);
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Discount Code Input
                    TextField(
                      controller: _discountCodeController,
                      decoration: InputDecoration(
                        labelText: 'İndirim Kodu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            ref.read(paymentProvider.notifier)
                              .applyDiscountCode(_discountCodeController.text);
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Payment Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Toplam Tutar',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          '${finalTotal.toStringAsFixed(2)} TL',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Para Üstü',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          '${paymentState.changeDue.toStringAsFixed(2)} TL',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Error Message
                    if (paymentState.errorMessage != null)
                      Text(
                        paymentState.errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Payment Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: paymentState.isLoading ? null : _processPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: paymentState.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Ödemeyi Tamamla'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ref.read(paymentProvider.notifier).cancelPayment();
                              context.go('/tables');
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('İptal'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _discountController.dispose();
    _discountCodeController.dispose();
    super.dispose();
  }
} 