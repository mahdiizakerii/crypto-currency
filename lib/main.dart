import 'package:crypto_currency/config/services/biometric_preference_service.dart';
import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_bloc.dart';
import 'package:crypto_currency/feature/news/presentation/bloc/news_bloc.dart';
import 'package:crypto_currency/feature/collectibles/presentation/bloc/collectibles_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/locator.dart';
import 'package:crypto_currency/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  setup();
  runApp(const TonKeeperApp());
}

class TonKeeperApp extends StatelessWidget {
  const TonKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BiometricService>.value(
          value: locator<BiometricService>(),
        ),
        RepositoryProvider<BiometricPreferenceService>.value(
          value: locator<BiometricPreferenceService>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WalletBloc>(create: (_) => locator<WalletBloc>()),
          BlocProvider<LoginBloc>(create: (_) => locator<LoginBloc>()),
          BlocProvider<MarketBloc>(create: (_) => locator<MarketBloc>()),
          BlocProvider<NewsBloc>(create: (_) => locator<NewsBloc>()),
          BlocProvider<CollectiblesBloc>(
            create: (_) => locator<CollectiblesBloc>(),
          ),
        ],
        child: MaterialApp(
          title: 'TonKeeper',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          initialRoute: AppRoutes.login,
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}
