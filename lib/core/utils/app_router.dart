import 'package:crypto_currency/feature/login/presentation/pages/login_page.dart';
import 'package:crypto_currency/feature/wallet/presentation/pages/wallet_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const login = '/login';
  static const wallet = '/wallet';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LoginPage(),
        );
      case AppRoutes.wallet:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const WalletPage(),
        );
      default:
        return null;
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => _UnknownRoutePage(routeName: settings.name),
    );
  }
}

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage({required this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Page not found: ${routeName ?? '/'}')),
    );
  }
}
