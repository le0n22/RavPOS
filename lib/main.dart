import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/core/router/app_router.dart';
import 'package:ravpos/core/storage/storage_factory.dart';
import 'package:ravpos/core/theme/app_theme.dart' as app_theme;
import 'package:ravpos/core/theme/theme_provider.dart';
import 'package:ravpos/core/constants/app_constants.dart';
import 'package:ravpos/features/users/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database for different platforms
  // if (kIsWeb) {
  //   // Initialize for web
  //   print('Initializing database for web platform');
  //   databaseFactory = databaseFactoryFfiWeb;
  // } else {
  //   // Initialize for desktop
  //   print('Initializing database for non-web platform');
  // }
  
  // Initialize storage with platform-specific implementation
  // try {
  //   print('Initializing storage...');
  //   await StorageFactory.getInstance();
  //   print('Storage initialized successfully!');
  // } catch (e) {
  //   print('Error initializing storage: $e');
  // }
  
  // Ensure database is properly initialized
  // try {
  //   print('Ensuring database is properly initialized...');
  //   final dbHelper = DatabaseHelper();
  //   await dbHelper.ensureDatabaseInitialized();
  //   print('Database initialization completed!');
  // } catch (e) {
  //   print('Error initializing database: $e');
  // }
  
  final container = ProviderContainer();
  await container.read(userProvider.notifier).autoLogin();

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        final themeMode = ref.watch(themeProvider);
        return MaterialApp.router(
          title: AppConstants.appName,
                     theme: app_theme.AppTheme.lightTheme,           darkTheme: app_theme.AppTheme.darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          // Enable responsive design for web
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
