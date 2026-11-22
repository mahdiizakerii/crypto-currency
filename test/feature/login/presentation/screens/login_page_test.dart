import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/pressentation/login_page.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('enters and deletes digits without showing the passcode', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const LoginPage()),
    );

    expect(find.text('Enter Passcode'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('digit-1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('digit-2')));
    await tester.pump();

    expect(find.bySemanticsLabel('Digit 1 entered'), findsOneWidget);
    expect(find.bySemanticsLabel('Digit 2 entered'), findsOneWidget);
    expect(find.text('12'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('delete-digit')));
    await tester.pump();

    expect(find.bySemanticsLabel('Digit 1 entered'), findsOneWidget);
    expect(find.bySemanticsLabel('Digit 2 not entered'), findsOneWidget);
  });

  testWidgets('opens the wallet after the correct passcode', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      BlocProvider<WalletBloc>(
        create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
        child: MaterialApp(theme: AppTheme.dark, home: const LoginPage()),
      ),
    );

    for (var index = 0; index < 4; index++) {
      await tester.tap(find.byKey(const ValueKey('digit-1')));
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
