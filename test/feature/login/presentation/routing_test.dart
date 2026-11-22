import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/core/utils/app_router.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('four-digit passcode opens the wallet route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider<WalletBloc>(
        create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
        child: MaterialApp(
          initialRoute: AppRoutes.login,
          onGenerateRoute: AppRouter.onGenerateRoute,
          onUnknownRoute: AppRouter.onUnknownRoute,
        ),
      ),
    );

    for (final digit in ['1', '2', '3', '4']) {
      await tester.tap(find.byKey(ValueKey('digit-$digit')));
      await tester.pump();
    }

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Your wallet is empty'), findsOneWidget);
  });
}

class _EmptyWalletRepository extends WalletRepository {
  @override
  Future<DataState<WalletEntities>> getWallet() async {
    return const DataSuccess(
      WalletEntities(
        success: true,
        data: WalletData(
          totalBalanceUsd: 0,
          walletAddress: null,
          walletType: null,
          isBiometricEnabled: false,
          assets: [],
        ),
      ),
    );
  }
}
