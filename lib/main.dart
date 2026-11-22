<<<<<<< HEAD
<<<<<<< HEAD
import 'package:tonkeeper/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:tonkeeper/feature/wallet/presentation/bloc/wallet_status.dart';
import 'package:tonkeeper/locator.dart';
=======
import 'package:crypto_currency/feature/login/presentation/pages/login_page.dart';
>>>>>>> feature/login
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

<<<<<<< HEAD
void main() async {
=======
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/pages/wallet_page.dart';
import 'package:crypto_currency/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
>>>>>>> feature/wallet
  setup();
  runApp(const CryptoCurrencyApp());
}

class CryptoCurrencyApp extends StatelessWidget {
  const CryptoCurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text('TonKeeper'),
        centerTitle: true,
      ),
      body: Center(
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state.walletStatus is WalletLoading) {
              return const CircularProgressIndicator();
            } else if (state.walletStatus is WalletLoaded) {
              return Text('Wallet Data Loaded');
            } else if (state.walletStatus is WalletError) {
              return Text((state.walletStatus as WalletError).message);
            } else {
              return Text('Unknown state');
            }
          },
        ),
=======
    return MaterialApp(
      title: 'TonKeeper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: BlocProvider<WalletBloc>.value(
        value: locator<WalletBloc>(),
        child: const WalletPage(),
>>>>>>> feature/wallet
      ),
=======
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
>>>>>>> feature/login
    );
  }
}
