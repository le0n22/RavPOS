import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ravpos/core/security/permission_manager.dart';
import 'package:ravpos/features/auth/providers/auth_provider.dart';
import 'package:ravpos/core/theme/theme_provider.dart';
import 'package:ravpos/shared/models/user_role.dart';
import 'package:ravpos/shared/models/app_user.dart';
import 'package:ravpos/features/users/providers/user_provider.dart';

class AdminSidebar extends ConsumerStatefulWidget {
  final bool isCollapsed;
  final VoidCallback onToggle;
  final String currentRoute;

  const AdminSidebar({
    super.key,
    required this.isCollapsed,
    required this.onToggle,
    required this.currentRoute,
  });

  @override
  ConsumerState<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends ConsumerState<AdminSidebar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(AdminSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(currentUserAsyncProvider);
    final user = authState.valueOrNull;
    final canAccessManagement = ref.watch(canAccessManagementProvider);
    final themeMode = ref.watch(themeProvider);
    
    if (user == null) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.isCollapsed ? 80 : 280,
      child: Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildNavigationItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    route: '/admin/dashboard',
                    isSelected: widget.currentRoute == '/admin/dashboard',
                  ),
                  if (canAccessManagement) ...[
                    _buildSectionHeader('Yönetim'),
                    _buildNavigationItem(
                      icon: Icons.people,
                      title: 'Kullanıcılar',
                      route: '/admin/users',
                      isSelected: widget.currentRoute == '/admin/users',
                    ),
                    _buildNavigationItem(
                      icon: Icons.inventory,
                      title: 'Ürünler',
                      route: '/admin/products',
                      isSelected: widget.currentRoute == '/admin/products',
                    ),
                    _buildNavigationItem(
                      icon: Icons.category,
                      title: 'Kategoriler',
                      route: '/admin/categories',
                      isSelected: widget.currentRoute == '/admin/categories',
                    ),
                  ],
                  _buildSectionHeader('Satış'),
                  _buildNavigationItem(
                    icon: Icons.receipt_long,
                    title: 'Siparişler',
                    route: '/admin/orders',
                    isSelected: widget.currentRoute == '/admin/orders',
                  ),
                  _buildNavigationItem(
                    icon: Icons.table_restaurant,
                    title: 'Masalar',
                    route: '/admin/tables',
                    isSelected: widget.currentRoute == '/admin/tables',
                  ),
                  _buildSectionHeader('Raporlar'),
                  _buildNavigationItem(
                    icon: Icons.analytics,
                    title: 'Satış Raporları',
                    route: '/admin/reports/sales',
                    isSelected: widget.currentRoute == '/admin/reports/sales',
                  ),
                  _buildNavigationItem(
                    icon: Icons.inventory_2,
                    title: 'Stok Raporları',
                    route: '/admin/reports/inventory',
                    isSelected: widget.currentRoute == '/admin/reports/inventory',
                  ),
                  _buildSectionHeader('Ayarlar'),
                  _buildNavigationItem(
                    icon: Icons.settings,
                    title: 'Ayarlar',
                    route: '/admin/settings',
                    isSelected: widget.currentRoute == '/admin/settings',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _buildFooter(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          if (!widget.isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Panel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'RavPOS',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
          IconButton(
            onPressed: widget.onToggle,
            icon: Icon(
              widget.isCollapsed ? Icons.menu_open : Icons.menu,
            ),
            tooltip: widget.isCollapsed ? 'Genişlet' : 'Daralt',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    if (widget.isCollapsed) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 153),
        ),
      ),
    );
  }

    Widget _buildNavigationItem({    required IconData icon,    required String title,    required String route,    required bool isSelected,  }) {    final listTile = ListTile(      leading: Icon(        icon,        color: isSelected            ? Theme.of(context).colorScheme.primary            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 179),      ),      title: widget.isCollapsed          ? null          : Text(              title,              style: TextStyle(                color: isSelected                    ? Theme.of(context).colorScheme.primary                    : Theme.of(context).colorScheme.onSurface,                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,              ),            ),      selected: isSelected,      selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 26),      shape: RoundedRectangleBorder(        borderRadius: BorderRadius.circular(8),      ),      onTap: () => context.go(route),      contentPadding: widget.isCollapsed          ? const EdgeInsets.symmetric(horizontal: 16)          : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),    );    return Container(      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),      child: widget.isCollapsed          ? Tooltip(              message: title,              child: listTile,            )          : listTile,    );  }

  Widget _buildFooter(BuildContext context, AppUser user) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (!widget.isCollapsed) ...[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 51),
                child: Icon(
                  _getIconForRole(user.role),
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
                ),
              ),
              title: Text(
                user.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(user.role.displayName),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
          ],
          Row(
            mainAxisAlignment: widget.isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  ref.watch(themeProvider) == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
                tooltip: 'Tema Değiştir',
              ),
              if (!widget.isCollapsed) ...[
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _showLogoutDialog(context),
                  tooltip: 'Çıkış Yap',
                ),
              ] else ...[
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'logout':
                        _showLogoutDialog(context);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'logout',
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Çıkış Yap'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Oturumu kapatmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(userProvider.notifier).logout();
              context.go('/tables'); // Redirect to main app
            },
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.cashier:
        return Icons.point_of_sale;
      case UserRole.waiter:
        return Icons.room_service;
    }
  }
} 