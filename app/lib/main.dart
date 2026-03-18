import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/favorites_manager.dart';
import 'package:formation_flutter/model/scan_history.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/screens/auth/login_screen.dart';
import 'package:formation_flutter/screens/auth/register_screen.dart';
import 'package:formation_flutter/screens/homepage/favorites_screen.dart';
import 'package:formation_flutter/screens/homepage/homepage_screen.dart';
import 'package:formation_flutter/screens/product/product_page.dart';
import 'package:formation_flutter/screens/product/scanner_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/', builder: (_, _) => HomePage()),
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
    GoRoute(path: '/scanner', builder: (_, _) => const ScannerScreen()),
    GoRoute(path: '/favorites', builder: (_, _) => const FavoritesScreen()),
    GoRoute(
      path: '/product',
      builder: (_, GoRouterState state) =>
          ProductPage(barcode: state.extra as String),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanHistoryManager()),
        ChangeNotifierProvider(create: (_) => FavoritesManager()),
      ],
      child: MaterialApp.router(
        title: 'Open Food Facts',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          extensions: [OffThemeExtension.defaultValues()],
          fontFamily: 'Avenir',
          dividerTheme: DividerThemeData(color: AppColors.grey2, space: 1.0),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.blue,
            unselectedItemColor: AppColors.grey2,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          ),
          navigationBarTheme: const NavigationBarThemeData(
            indicatorColor: AppColors.blue,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}
