import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/pressentation/login_page.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setup();
  runApp(const CryptoCurrencyApp());
}

class CryptoCurrencyApp extends StatelessWidget {
  const CryptoCurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>.value(
      value: locator<WalletBloc>(),
      child: MaterialApp(
        title: 'TonKeeper',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const LoginPage(),
      ),
    );
  }
}
