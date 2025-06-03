import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/core/database/repositories/order_repository.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:ravpos/shared/providers/providers.dart';
import 'package:ravpos/shared/models/table_report.dart';

class ReportNotifier extends AsyncNotifier<ReportData> {
  late final OrderRepository _orderRepository;

  @override
  Future<ReportData> build() async {
    _orderRepository = ref.watch(orderRepositoryProvider);
    return const ReportData();
  }

  Future<void> generateReport(DateTime startDate, DateTime endDate) async {
    state = const AsyncValue.loading();
    
    try {
      // Get all completed orders in the date range
      final orders = await _orderRepository.getCompletedOrdersByDateRange(startDate, endDate);
      
      if (orders.isEmpty) {
        state = const AsyncValue.data(ReportData());
        return;
      }
      
      // Calculate report metrics
      double totalSales = 0.0;
      double totalDiscountGiven = 0.0;
      Map<String, double> salesByPaymentMethod = {};
      Map<DateTime, double> dailySalesData = {};
      Map<String, ProductSales> productSalesMap = {};
      
      // Saatlik sipariş yoğunluğu hesaplama
      final Map<int, int> hourlyOrderCounts = {};
      
      // Masa bazlı raporlar hesaplama
      final Map<String, TableReport> tableReports = {};
      
      // Process each order
      for (final order in orders) {
        // Calculate total sales (after discount)
        final orderTotal = order.totalAmount - (order.discountAmount ?? 0);
        totalSales += orderTotal;
        
        // Track discounts
        if (order.discountAmount != null && order.discountAmount! > 0) {
          totalDiscountGiven += order.discountAmount!;
        }
        
        // Track payment methods
        final paymentMethodName = order.paymentMethod?.displayName ?? 'Unknown';
        salesByPaymentMethod[paymentMethodName] = 
            (salesByPaymentMethod[paymentMethodName] ?? 0.0) + orderTotal;
        
        // Track daily sales
        final orderDate = DateTime(
          order.createdAt.year,
          order.createdAt.month,
          order.createdAt.day,
        );
        dailySalesData[orderDate] = (dailySalesData[orderDate] ?? 0.0) + orderTotal;
        
        // Track product sales
        for (final item in order.items) {
          if (productSalesMap.containsKey(item.productId)) {
            final existingProduct = productSalesMap[item.productId]!;
            productSalesMap[item.productId] = ProductSales(
              productId: item.productId,
              productName: item.productName,
              totalQuantitySold: existingProduct.totalQuantitySold + item.quantity,
              totalRevenue: existingProduct.totalRevenue + item.totalPrice,
            );
          } else {
            productSalesMap[item.productId] = ProductSales(
              productId: item.productId,
              productName: item.productName,
              totalQuantitySold: item.quantity,
              totalRevenue: item.totalPrice,
            );
          }
        }
        
        // Saatlik sipariş yoğunluğu hesaplama
        final date = order.updatedAt ?? order.createdAt;
        if (date != null) {
          hourlyOrderCounts[date.hour] = (hourlyOrderCounts[date.hour] ?? 0) + 1;
        }
        
        // Masa bazlı raporlar
        final tableNumber = order.tableNumber ?? '-';
        if (tableReports.containsKey(tableNumber)) {
          final existing = tableReports[tableNumber]!;
          tableReports[tableNumber] = existing.copyWith(
            orderCount: existing.orderCount + 1,
            totalSales: existing.totalSales + order.totalAmount,
          );
        } else {
          tableReports[tableNumber] = TableReport(
            tableNumber: tableNumber,
            orderCount: 1,
            totalSales: order.totalAmount,
          );
        }
      }
      
      // Calculate average order value
      final averageOrderValue = orders.isNotEmpty ? totalSales / orders.length : 0.0;
      
      // Get top selling products (sorted by revenue)
      final topSellingProducts = productSalesMap.values.toList()
        ..sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
      
      // Limit to top 10 products
      final topProducts = topSellingProducts.take(10).toList();
      
      // Create and return the report data
      final reportData = ReportData(
        totalSales: totalSales,
        totalOrders: orders.length,
        averageOrderValue: averageOrderValue,
        totalDiscountGiven: totalDiscountGiven,
        salesByPaymentMethod: salesByPaymentMethod,
        topSellingProducts: topProducts,
        dailySalesData: dailySalesData,
        orders: orders,
        hourlyOrderCounts: hourlyOrderCounts,
        tableReports: tableReports,
      );
      
      state = AsyncValue.data(reportData);
    } catch (error, stackTrace) {
      state = AsyncValue.error(
        error, 
        stackTrace,
      );
    }
  }

  Future<void> generateDailyReport() async {
    final today = DateTime.now();
    await generateReport(today, today);
  }

  Future<void> generateWeeklyReport() async {
    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    await generateReport(weekStart, today);
  }

  Future<void> generateMonthlyReport() async {
    final today = DateTime.now();
    final monthStart = DateTime(today.year, today.month, 1);
    await generateReport(monthStart, today);
  }

  Future<void> generateSummaryReport(DateTime startDate, DateTime endDate) async {
    state = const AsyncValue.loading();
    try {
      final summary = await _orderRepository.fetchSummaryReport(startDate, endDate);
      state = AsyncValue.data(summary);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final reportProvider = AsyncNotifierProvider<ReportNotifier, ReportData>(() {
  return ReportNotifier();
}); 