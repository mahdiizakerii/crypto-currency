import 'package:crypto_currency/config/services/biometric_preference_service.dart';
import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/feature/login/pressentation/login_page.dart';
import 'package:crypto_currency/feature/wallet/presentation/screens/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const String login = '/';
  static const String wallet = '/wallet';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    wallet: (context) => WalletPage(
      biometricService: context.read<BiometricService>(),
      biometricPreferenceService: context.read<BiometricPreferenceService>(),
    ),
  };
}
