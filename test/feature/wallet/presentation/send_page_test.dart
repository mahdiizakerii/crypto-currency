import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/domain/repositories/market_repository.dart';
import 'package:crypto_currency/feature/coinlist/domain/use_cases/get_coin_chart_use_case.dart';
import 'package:crypto_currency/feature/coinlist/domain/use_cases/get_market_coins_use_case.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_bloc.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/screens/send_page.dart';
import 'package:crypto_currency/feature/wallet/presentation/screens/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows an empty state and keeps sending disabled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SendPage()));

    expect(find.text('No assets to send'), findsOneWidget);
    expect(
      find.text(
        'Your wallet is empty. Add an asset before creating a transfer.',
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets('opening a wallet asset shows its token page', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<WalletBloc>(
            create: (_) => WalletBloc(
              GetWalletUseCase(
                _FakeWalletRepository([
                  {
                    'id': '1',
                    'name': 'Bitcoin',
                    'symbol': 'BTC',
                    'current_price': 64000,
                  },
                ]),
              ),
            ),
          ),
          BlocProvider<MarketBloc>(
            create: (_) => MarketBloc(
              getMarketCoins: GetMarketCoinsUseCase(_FakeMarketRepository()),
              getCoinChart: GetCoinChartUseCase(_FakeMarketRepository()),
            ),
          ),
        ],
        child: const MaterialApp(home: WalletPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Bitcoin'));
    await tester.pumpAndSettle();

    expect(find.text('Price chart'), findsOneWidget);
    expect(find.text('Bitcoin (BTC) market price'), findsOneWidget);
  });

  testWidgets('wallet send shortcut has no action', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<WalletBloc>(
            create: (_) =>
                WalletBloc(GetWalletUseCase(_FakeWalletRepository(const []))),
          ),
          BlocProvider<MarketBloc>(
            create: (_) => MarketBloc(
              getMarketCoins: GetMarketCoinsUseCase(_FakeMarketRepository()),
              getCoinChart: GetCoinChartUseCase(_FakeMarketRepository()),
            ),
          ),
        ],
        child: const MaterialApp(home: WalletPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.bySemanticsLabel('Send'));
    await tester.pumpAndSettle();

    expect(find.text('Your wallet is empty'), findsOneWidget);
    expect(find.text('No assets to send'), findsNothing);
  });
}

class _FakeWalletRepository extends WalletRepository {
  _FakeWalletRepository(this.assets);

  final List<Object?> assets;

  @override
  Future<DataState<WalletEntities>> getWallet() async {
    return DataSuccess(
      WalletEntities(
        success: true,
        data: WalletData(
          totalBalanceUsd: 0,
          walletAddress: null,
          walletType: null,
          isBiometricEnabled: false,
          assets: assets,
        ),
      ),
    );
  }
}

class _FakeMarketRepository extends MarketRepository {
  @override
  Future<List<MarketCoin>> getCoins() async => const [];

  @override
  Future<List<CoinPricePoint>> getCoinChart(String id, int days) async =>
      const [];
}
