import 'package:crypto_currency/feature/login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF080D3B);

    return MaterialApp(
      title: 'Crypto Currency',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF304BFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
