import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_status.dart';
import 'package:crypto_currency/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  setup();
  runApp(
    MaterialApp(
      title: 'TonKeeper',
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WalletBloc>(create: (context) => locator<WalletBloc>()),
        ],
        child: Main(),
      ),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WalletBloc>(context).add(FetchWalletData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
    );
  }
}
