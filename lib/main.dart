import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/pressentation/login_page.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setup();
  runApp(const TonKeeperApp());
}

class TonKeeperApp extends StatelessWidget {
  const TonKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WalletBloc>.value(value: locator<WalletBloc>()),
        BlocProvider<LoginBloc>(create: (_) => locator<LoginBloc>()),
      ],
      child: MaterialApp(
        title: 'TonKeeper',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const LoginPage(),
      ),
    );
  }
}
