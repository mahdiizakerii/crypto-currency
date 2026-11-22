import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/presentation/screens/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Currency',
      theme: AppTheme.dark,
      home: const LoginPage(),
    );
  }
}
