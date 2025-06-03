import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/core/database/repositories/order_repository.dart';
import 'package:ravpos/core/database/repositories/user_repository.dart';
import 'package:ravpos/core/network/api_service.dart';

// Product providers
export '../../features/products/providers/product_provider.dart';
export '../../features/products/providers/category_provider.dart';

// Order providers
export '../../features/orders/providers/order_provider.dart';
export '../../features/orders/providers/cart_provider.dart';

// Dashboard provider
export '../../features/dashboard/providers/dashboard_provider.dart';

// Table provider
export '../../features/tables/providers/table_provider.dart';

// Payment provider
export '../../features/payments/providers/payment_provider.dart';

// Report provider
export '../../features/reports/providers/report_provider.dart';

// Online order provider
export '../../features/online_orders/providers/online_order_provider.dart';

// User provider
export '../../features/users/providers/user_provider.dart';

// Settings provider
export '../../core/settings/providers/settings_provider.dart';

// API service provider
export '../../core/network/api_service.dart';

// User repository provider
export 'package:ravpos/features/users/providers/user_provider.dart' show userRepositoryProvider;

// Order repository provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return OrderRepository(apiService);
}); 