import 'package:crypto_currency/feature/login/presentation/pages/login_page.dart';
import 'package:crypto_currency/feature/wallet/presentation/pages/wallet_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/';
  static const String wallet = '/wallet';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    wallet: (context) => const WalletPage(),
  };
}
