class AppConstants {
  // App information
  static const String appName = 'RavPOS';
  static const String appVersion = '1.0.0';
  
  // Navigation routes
  static const String dashboardRoute = '/';
  static const String productsRoute = '/products';
  static const String ordersRoute = '/orders';
  static const String paymentsRoute = '/payments';
  static const String reportsRoute = '/reports';
  static const String tablesRoute = '/tables';
  static const String onlineOrdersRoute = '/online-orders';
  static const String loginRoute = '/login';
  
  // Database
  static const String dbName = 'ravpos.db';
  static const int dbVersion = 1;
  
  // API
  static const String baseUrl = 'http://localhost:5000/api'; // Replace with your actual backend API URL
  
  // Localization
  static const String defaultLocale = 'tr';
  
  // Layout
  static const double mobileWidth = 600;
  static const double tabletWidth = 1200;
} 