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
