import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ravpos/features/admin/widgets/admin_sidebar.dart';
import 'package:ravpos/features/admin/widgets/breadcrumb_navigation.dart';

class AdminLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String title;

  const AdminLayout({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  ConsumerState<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends ConsumerState<AdminLayout> {
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return _buildMobileLayout(currentRoute);
    }

    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            isCollapsed: _isSidebarCollapsed && !isMobile,
            onToggle: () => setState(() {
              _isSidebarCollapsed = !_isSidebarCollapsed;
            }),
            currentRoute: currentRoute,
          ),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(context, currentRoute),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(String currentRoute) {
    return Scaffold(
      drawer: Drawer(
        child: AdminSidebar(
          isCollapsed: false,
          onToggle: () => Navigator.of(context).pop(),
          currentRoute: currentRoute,
        ),
      ),
      appBar: _buildMobileAppBar(context, currentRoute),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: widget.child,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String currentRoute) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BreadcrumbNavigation(currentRoute: currentRoute),
        ],
      ),
      actions: [
        _buildQuickActions(context),
        const SizedBox(width: 16),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context, String currentRoute) {
    return AppBar(
      title: Text(widget.title),
      actions: [
        _buildQuickActions(context),
        const SizedBox(width: 8),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // Trigger refresh for current page
            setState(() {});
          },
          tooltip: 'Yenile',
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            _showNotificationsDialog(context);
          },
          tooltip: 'Bildirimler',
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            _showHelpDialog(context);
          },
          tooltip: 'Yardım',
        ),
      ],
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bildirimler'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: ListView(
            children: [
              _buildNotificationItem(
                'Düşük Stok Uyarısı',
                '5 ürün kritik stok seviyesinde',
                Icons.warning,
                Colors.orange,
              ),
              _buildNotificationItem(
                'Yeni Sipariş',
                '3 yeni online sipariş alındı',
                Icons.shopping_cart,
                Colors.blue,
              ),
              _buildNotificationItem(
                'Sistem Güncellesi',
                'Yeni güncelleme mevcut',
                Icons.system_update,
                Colors.green,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to notifications page
            },
            child: const Text('Tümünü Gör'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 51),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      dense: true,
      onTap: () {
        // Handle notification tap
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yardım'),
        content: const SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hızlı Kısayollar:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Ctrl+N: Yeni öğe ekle'),
              Text('• Ctrl+S: Kaydet'),
              Text('• Ctrl+F: Ara'),
              Text('• F5: Yenile'),
              SizedBox(height: 16),
              Text(
                'Destek için:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Email: support@ravpos.com'),
              Text('Telefon: +90 (212) 555 0123'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Open documentation
            },
            child: const Text('Dokümantasyon'),
          ),
        ],
      ),
    );
  }
} 