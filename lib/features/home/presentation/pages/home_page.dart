import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive_layout.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).uri.path;
    setState(() {
      _selectedIndex = _getIndexFromLocation(location);
    });
  }

  int _getIndexFromLocation(String location) {
    switch (location) {
      case AppConstants.dashboardRoute:
        return 0;
      case AppConstants.productsRoute:
        return 1;
      case AppConstants.ordersRoute:
        return 2;
      case AppConstants.paymentsRoute:
        return 3;
      case AppConstants.reportsRoute:
        return 4;
      default:
        return 0;
    }
  }

  void _navigateToDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go(AppConstants.dashboardRoute);
        break;
      case 1:
        context.go(AppConstants.productsRoute);
        break;
      case 2:
        context.go(AppConstants.ordersRoute);
        break;
      case 3:
        context.go(AppConstants.paymentsRoute);
        break;
      case 4:
        context.go(AppConstants.reportsRoute);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = !ResponsiveLayout.isMobile(context);
    
    return Scaffold(
      body: Row(
        children: [
          // Navigation rail for tablet/desktop
          if (isTablet)
            NavigationRail(
              extended: MediaQuery.of(context).size.width > 1200,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _navigateToDestination,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory),
                  label: Text('Products'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long),
                  label: Text('Orders'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.payments),
                  label: Text('Payments'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text('Reports'),
                ),
              ],
            ),
          
          // Main content
          Expanded(child: widget.child),
        ],
      ),
      
      // Bottom navigation for mobile
      bottomNavigationBar: isTablet ? null : BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateToDestination,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
} 