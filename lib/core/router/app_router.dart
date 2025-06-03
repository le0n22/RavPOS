import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ravpos/core/constants/app_constants.dart';
import 'package:ravpos/features/admin/pages/admin_settings_page.dart';
import 'package:ravpos/core/router/navigation_shell.dart';
import 'package:ravpos/features/auth/providers/auth_provider.dart';
import 'package:ravpos/shared/models/user_role.dart';
import 'package:ravpos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:ravpos/features/management/pages/category_management_page.dart';
import 'package:ravpos/features/management/pages/database_management_page.dart';
import 'package:ravpos/features/management/pages/management_dashboard_page.dart';
import 'package:ravpos/features/management/pages/product_management_page.dart';
import 'package:ravpos/features/management/pages/user_management_page.dart';
import 'package:ravpos/features/orders/presentation/pages/orders_page.dart';
import 'package:ravpos/features/orders/presentation/pages/test_order_page.dart';
import 'package:ravpos/features/payments/presentation/pages/payment_page.dart';
import 'package:ravpos/features/products/presentation/pages/products_page.dart';
import 'package:ravpos/features/reports/presentation/pages/reports_page.dart';
import 'package:ravpos/features/tables/pages/tables_page.dart';
import 'package:ravpos/features/tables/pages/table_selection_page.dart';
import 'package:ravpos/features/tables/pages/table_order_page.dart';
import 'package:ravpos/features/online_orders/pages/online_orders_page.dart';
import 'package:ravpos/features/admin/layouts/admin_layout.dart';
import 'package:ravpos/features/admin/pages/admin_dashboard_page.dart';
import 'package:ravpos/features/admin/pages/admin_tables_page.dart';
import 'package:ravpos/features/auth/pages/login_page.dart';
import 'package:ravpos/features/users/providers/user_provider.dart';
import 'package:ravpos/features/products/presentation/pages/discounts_page.dart';

/// Route names for easy reference
class AppRoutes {
  static const String dashboard = 'dashboard';
  static const String products = 'products';
  static const String orders = 'orders';
  static const String payments = 'payments';
  static const String reports = 'reports';
  static const String settings = 'settings';
  static const String testOrder = 'test_order';
  static const String tables = 'tables';
  static const String tableSelection = 'tableSelection';
  static const String tableOrder = 'table_order';
  static const String onlineOrders = 'onlineOrders';
  
  // Management routes
  static const String managementDashboard = 'managementDashboard';
  static const String productManagement = 'productManagement';
  static const String categoryManagement = 'categoryManagement';
  static const String userManagement = 'userManagement';
  static const String databaseManagement = 'databaseManagement';
  
  // Admin routes
  static const String adminDashboard = 'adminDashboard';
  static const String adminUsers = 'adminUsers';
  static const String adminProducts = 'adminProducts';
  static const String adminCategories = 'adminCategories';
  static const String adminOrders = 'adminOrders';
  static const String adminTables = 'adminTables';
  static const String adminReports = 'adminReports';
  static const String adminSettings = 'adminSettings';
  static const String login = 'login';
}

/// Main router configuration for the app
final appRouterProvider = Provider<GoRouter>((ref) {
  final currentUserAsync = ref.watch(currentUserAsyncProvider);
  final currentUser = currentUserAsync.valueOrNull;
  
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const ErrorScreen(),
    redirect: (context, state) {
      // Wait for user state to load
      if (currentUserAsync.isLoading) return null;
      final user = currentUser;
      final isLoggingIn = state.uri.path == '/login';
      
      // If user is not authenticated and not on login page, redirect to login
      if (user == null && !isLoggingIn) {
        return '/login';
      }
      
      // If user is authenticated and on login page, redirect to dashboard
      if (user != null && isLoggingIn) {
        return AppConstants.dashboardRoute;
      }
      
      // Check if trying to access management or admin routes
      if (state.uri.path.startsWith('/management') || state.uri.path.startsWith('/admin')) {
        // If user is not authenticated or not an admin, redirect to tables
        if (user == null || user.role != UserRole.admin) {
          return AppConstants.tablesRoute;
        }
      }
      
      // No redirection needed
      return null;
    },
    routes: [
      // Add login route before ShellRoute
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      
      ShellRoute(
        builder: (context, state, child) => NavigationShell(child: child),
        routes: [
          GoRoute(
            path: AppConstants.dashboardRoute,
            name: AppRoutes.dashboard,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const DashboardPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: AppConstants.productsRoute,
            name: AppRoutes.products,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProductsPage(tableId: 'default'),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/tables/:tableId/order',
            name: AppRoutes.tableOrder,
            pageBuilder: (context, state) {
              final tableId = state.pathParameters['tableId'] ?? '';
              final orderId = state.uri.queryParameters['orderId'];
              return CustomTransitionPage(
                key: state.pageKey,
                child: TableOrderPage(tableId: tableId, orderId: orderId),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            },
          ),
          GoRoute(
            path: '/tables/:tableId/adisyon',
            name: 'table_adisyon',
            pageBuilder: (context, state) {
              final tableId = state.pathParameters['tableId'] ?? '';
              return CustomTransitionPage(
                key: state.pageKey,
                child: TableOrderPage(tableId: tableId),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            },
          ),
          GoRoute(
            path: AppConstants.ordersRoute,
            name: AppRoutes.orders,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const OrdersPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: AppConstants.paymentsRoute,
            name: AppRoutes.payments,
            pageBuilder: (context, state) {
              // Check if extra parameter is passed
              final extra = state.extra;
              String? orderId;
              String? tableId;

              if (extra is Map<String, dynamic>) {
                orderId = extra['orderId'] as String?;
                tableId = extra['tableId'] as String?;
              } else {
                // Fallback to query parameters
                orderId = state.uri.queryParameters['orderId'];
                tableId = state.uri.queryParameters['tableId'];
              }

              return CustomTransitionPage(
                key: state.pageKey,
                child: PaymentPage(orderId: orderId, tableId: tableId),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            },
          ),
          GoRoute(
            path: AppConstants.reportsRoute,
            name: AppRoutes.reports,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ReportsPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/settings',
            name: AppRoutes.settings,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AdminSettingsPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/test-order',
            name: AppRoutes.testOrder,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const TestOrderPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/tables',
            name: AppRoutes.tables,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const TablesPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/online-orders',
            name: AppRoutes.onlineOrders,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const OnlineOrdersPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/discounts',
            name: 'discounts',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const DiscountsPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          // Management routes
          GoRoute(
            path: '/management',
            name: AppRoutes.managementDashboard,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ManagementDashboardPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            routes: [
              GoRoute(
                path: 'products',
                name: AppRoutes.productManagement,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ProductManagementPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'categories',
                name: AppRoutes.categoryManagement,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const CategoryManagementPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'users',
                name: AppRoutes.userManagement,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const UserManagementPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'database',
                name: AppRoutes.databaseManagement,
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const DatabaseManagementPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
            ],
          ),
          // Admin routes with separate layout
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return AdminLayout(
                child: navigationShell,
                title: _getAdminPageTitle(state.uri.path),
              );
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/admin',
                    redirect: (context, state) => '/admin/dashboard',
                  ),
                  GoRoute(
                    path: '/admin/dashboard',
                    name: AppRoutes.adminDashboard,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const AdminDashboardPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  GoRoute(
                    path: '/admin/users',
                    name: AppRoutes.adminUsers,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const UserManagementPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  GoRoute(
                    path: '/admin/products',
                    name: AppRoutes.adminProducts,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const ProductManagementPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  GoRoute(
                    path: '/admin/categories',
                    name: AppRoutes.adminCategories,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const CategoryManagementPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  GoRoute(
                    path: '/admin/orders',
                    name: AppRoutes.adminOrders,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const OrdersPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  GoRoute(
                    path: '/admin/tables',
                    name: AppRoutes.adminTables,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const AdminTablesPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  GoRoute(
                    path: '/admin/reports/sales',
                    name: AppRoutes.adminReports,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const ReportsPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  GoRoute(
                    path: '/admin/reports/inventory',
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const ReportsPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                  GoRoute(
                    path: '/admin/settings',
                    name: AppRoutes.adminSettings,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const AdminSettingsPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Helper function to get admin page title
String _getAdminPageTitle(String path) {
  switch (path) {
    case '/admin/dashboard':
      return 'Admin Dashboard';
    case '/admin/users':
      return 'Kullanıcı Yönetimi';
    case '/admin/products':
      return 'Ürün Yönetimi';
    case '/admin/categories':
      return 'Kategori Yönetimi';
    case '/admin/orders':
      return 'Sipariş Yönetimi';
    case '/admin/tables':
      return 'Masa Yönetimi';
    case '/admin/reports/sales':
      return 'Satış Raporları';
    case '/admin/reports/inventory':
      return 'Stok Raporları';
    case '/admin/settings':
      return 'Ayarlar';
    default:
      return 'Admin Panel';
  }
}

/// Helper extension methods for navigation
extension GoRouterExtension on BuildContext {
  void goToDashboard() => go(AppConstants.dashboardRoute);
  void goToProducts() => go(AppConstants.productsRoute);
  void goToOrders() => go(AppConstants.ordersRoute);
  void goToPayments() => go(AppConstants.paymentsRoute);
  void goToReports() => go(AppConstants.reportsRoute);
  void goToSettings() => go('/admin/settings');
  void goToTestOrder() => go('/test-order');
  void goToTables() => go(AppConstants.tablesRoute);
  void goToTableOrder(String tableId) => go('/tables/$tableId/order');
  void goToTableAdisyon(String tableId) => go('/tables/$tableId/adisyon');
  void goToOnlineOrders() => go('/online-orders');
  void goToManagement() => go('/management');
  void goToProductManagement() => go('/management/products');
  void goToCategoryManagement() => go('/management/categories');
  void goToUserManagement() => go('/management/users');
  void goToDatabaseManagement() => go('/management/database');
  
  // Admin navigation
  void goToAdmin() => go('/admin/dashboard');
  void goToAdminUsers() => go('/admin/users');
  void goToAdminProducts() => go('/admin/products');
  void goToAdminCategories() => go('/admin/categories');
  void goToAdminOrders() => go('/admin/orders');
  void goToAdminTables() => go('/admin/tables');
  void goToAdminReports() => go('/admin/reports/sales');
  void goToAdminSettings() => go('/admin/settings');
}

/// Error screen for handling navigation errors
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayfa Bulunamadı'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Üzgünüz, aradığınız sayfa bulunamadı.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.goToDashboard(),
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        ),
      ),
    );
  }
}
