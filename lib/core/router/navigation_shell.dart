import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ravpos/core/constants/app_constants.dart';
import 'package:ravpos/features/auth/providers/auth_provider.dart';
import 'package:ravpos/shared/models/user_role.dart';
import 'package:ravpos/features/users/providers/user_provider.dart';

/// Responsive navigation shell that adapts to different screen sizes
class NavigationShell extends ConsumerWidget {
  final Widget child;

  const NavigationShell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine screen size for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= AppConstants.mobileWidth;
    
    // Get current route for highlighting active navigation item
    final currentLocation = GoRouterState.of(context).uri.path;
    
    // Check if user is admin for management menu
    final authState = ref.watch(currentUserAsyncProvider);
    final isAdmin = authState.valueOrNull?.role == UserRole.admin;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle(currentLocation)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          const SizedBox(width: 8),
          // Admin Panel Button
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                context.go('/admin/dashboard');
              },
              tooltip: 'Admin Panel',
            ),
          // User Profile Button
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (value) {
              switch (value) {
                case 'login':
                  _showLoginDialog(context, ref);
                  break;
                case 'logout':
                  ref.read(userProvider.notifier).logout();
                  break;
                case 'profile':
                  // TODO: Show user profile
                  break;
              }
            },
            itemBuilder: (context) {
              final user = authState.valueOrNull;
              if (user != null) {
                return [
                  PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(user.role.icon),
                      title: Text(user.name),
                      subtitle: Text(user.role.displayName),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Çıkış Yap'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ];
              } else {
                return [
                  const PopupMenuItem(
                    value: 'login',
                    child: ListTile(
                      leading: Icon(Icons.login),
                      title: Text('Giriş Yap'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ];
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Show side navigation rail for tablet
          if (isTablet) _buildNavigationRail(context, currentLocation, isAdmin),
          // Main content area
          Expanded(child: child),
        ],
      ),
      // Show bottom navigation for mobile
      bottomNavigationBar: isTablet ? null : _buildBottomNavigationBar(context, currentLocation, isAdmin),
      floatingActionButton: _buildFloatingActionButton(context, currentLocation),
    );
  }

  // Build the navigation rail for tablet layout
  Widget _buildNavigationRail(BuildContext context, String currentLocation, bool isAdmin) {
    final selectedIndex = _getSelectedIndex(currentLocation);
    final isExtended = MediaQuery.of(context).size.width >= AppConstants.tabletWidth;
    
    return NavigationRail(
      selectedIndex: selectedIndex < 9 ? selectedIndex : 0,
      minExtendedWidth: 240,
      labelType: isExtended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
      selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary, size: 28),
      unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface.withAlpha(163), size: 24),
      selectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
      unselectedLabelTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(163)),
      onDestinationSelected: (index) {
        _navigateTo(context, index);
      },
      extended: isExtended,
      backgroundColor: Theme.of(context).colorScheme.surface,
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Dashboard'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Siparişler'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: Text('Raporlar'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.table_bar_outlined),
          selectedIcon: Icon(Icons.table_bar),
          label: Text('Masalar'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.cloud_download_outlined),
          selectedIcon: Icon(Icons.cloud_download),
          label: Text('Online Siparişler'),
        ),
        if (isAdmin)
          const NavigationRailDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: Text('Yönetim'),
          ),
      ],
    );
  }

  // Build the bottom navigation bar for mobile layout
  Widget _buildBottomNavigationBar(BuildContext context, String currentLocation, bool isAdmin) {
    final selectedIndex = _getSelectedIndex(currentLocation);
    
    return NavigationBar(
      selectedIndex: selectedIndex < 7 ? selectedIndex : 0,
      onDestinationSelected: (index) {
        _navigateTo(context, index);
      },
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Dashboard',
        ),
        const NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Siparişler',
        ),
        const NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Raporlar',
        ),
        const NavigationDestination(
          icon: Icon(Icons.table_bar_outlined),
          selectedIcon: Icon(Icons.table_bar),
          label: 'Masalar',
        ),
        const NavigationDestination(
          icon: Icon(Icons.cloud_download_outlined),
          selectedIcon: Icon(Icons.cloud_download),
          label: 'Online Siparişler',
        ),
        if (isAdmin)
          const NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Yönetim',
          ),
      ],
    );
  }
  
  // Build contextual floating action button based on current page
  Widget? _buildFloatingActionButton(BuildContext context, String currentLocation) {
    switch (currentLocation) {
      case AppConstants.dashboardRoute:
        return FloatingActionButton.extended(
          onPressed: () {
            context.go(AppConstants.ordersRoute);
          },
          icon: const Icon(Icons.add),
          label: const Text('Yeni Sipariş'),
        );
      case AppConstants.productsRoute:
        return FloatingActionButton(
          onPressed: () {
            // TODO: Add new product
          },
          child: const Icon(Icons.add),
        );
      case AppConstants.ordersRoute:
        return FloatingActionButton(
          onPressed: () {
            // TODO: Create new order
          },
          child: const Icon(Icons.add),
        );
      case AppConstants.onlineOrdersRoute:
        return FloatingActionButton.extended(
          onPressed: () {
            // Will be handled by the page
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Yenile'),
        );
      default:
        return null;
    }
  }

  // Navigate to the corresponding route based on selected index
  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppConstants.dashboardRoute);
        break;
      case 1:
        context.go(AppConstants.ordersRoute);
        break;
      case 2:
        context.go(AppConstants.reportsRoute);
        break;
      case 3:
        context.go(AppConstants.tablesRoute);
        break;
      case 4:
        context.go(AppConstants.onlineOrdersRoute);
        break;
      case 5:
        context.go('/admin/dashboard');
        break;
    }
  }

  // Get the selected index based on current location
  int _getSelectedIndex(String currentLocation) {
    if (currentLocation.startsWith(AppConstants.ordersRoute)) return 1;
    if (currentLocation.startsWith(AppConstants.reportsRoute)) return 2;
    if (currentLocation.startsWith(AppConstants.tablesRoute)) return 3;
    if (currentLocation.startsWith(AppConstants.onlineOrdersRoute)) return 4;
    if (currentLocation.startsWith('/admin')) return 5;
    return 0;
  }

  // Get page title based on current location
  String _getPageTitle(String currentLocation) {
    if (currentLocation.startsWith(AppConstants.ordersRoute)) return 'Siparişler';
    if (currentLocation.startsWith(AppConstants.reportsRoute)) return 'Raporlar';
    if (currentLocation.startsWith(AppConstants.tablesRoute)) return 'Masalar';
    if (currentLocation.startsWith(AppConstants.onlineOrdersRoute)) return 'Online Siparişler';
    if (currentLocation.startsWith('/admin')) return 'Yönetim';
    return 'RavPOS';
  }

  void _showLoginDialog(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Girişi'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(userProvider.notifier).login(
                  usernameController.text,
                  passwordController.text,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                  // If admin, redirect to admin panel
                  final user = ref.read(currentUserAsyncProvider).valueOrNull;
                  if (user?.role == UserRole.admin) {
                    context.go('/admin/dashboard');
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Giriş başarısız: $e')),
                  );
                }
              }
            },
            child: const Text('Giriş Yap'),
          ),
        ],
      ),
    );
  }
} 