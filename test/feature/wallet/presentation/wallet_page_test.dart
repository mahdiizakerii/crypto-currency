import 'dart:async';

import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/screens/wallet_page.dart';
import 'package:crypto_currency/feature/wallet/presentation/widgets/wallet_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the empty wallet and persistent navigation tabs', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({
      'biometric_login_enabled': 'true',
    });

    await tester.pumpWidget(
      BlocProvider<WalletBloc>(
        create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
        child: MaterialApp(theme: AppTheme.dark, home: const WalletPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Your wallet is empty'), findsOneWidget);
    expect(find.byType(WalletAppBar), findsOneWidget);
    expect(find.text(r'$0.00'), findsOneWidget);
    expect(find.text('Chart'), findsOneWidget);
    expect(find.byIcon(Icons.show_chart_rounded), findsOneWidget);
    expect(
      tester.getRect(find.text('Chart')).top -
          tester.getRect(find.byIcon(Icons.show_chart_rounded)).bottom,
      closeTo(4, 0.1),
    );
    expect(find.text('News'), findsOneWidget);
    expect(find.text('Collectibles'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Send'));
    await tester.pump();
    expect(find.text('Your wallet is empty'), findsOneWidget);

    expect(
      tester
          .widget<Switch>(find.byKey(const ValueKey('biometric-switch')))
          .value,
      isTrue,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      BlocProvider<WalletBloc>(
        create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
        child: MaterialApp(theme: AppTheme.dark, home: const WalletPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(
      tester
          .widget<Switch>(find.byKey(const ValueKey('biometric-switch')))
          .value,
      isTrue,
    );

    await tester.tap(find.byKey(const ValueKey('biometric-switch')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Switch>(find.byKey(const ValueKey('biometric-switch')))
          .value,
      isFalse,
    );
  });

  testWidgets('authenticates on resume when biometric login is enabled', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({
      'biometric_login_enabled': 'true',
    });
    final biometricService = _FakeBiometricService();

    await tester.pumpWidget(
      BlocProvider<WalletBloc>(
        create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
        child: MaterialApp(
          theme: AppTheme.dark,
          home: WalletPage(biometricService: biometricService),
        ),
      ),
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.text('Unlock wallet'), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(biometricService.authenticationCount, 1);
    expect(find.text('Your wallet is empty'), findsOneWidget);
  });

  testWidgets('does not authenticate on resume when biometrics are disabled', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    final biometricService = _FakeBiometricService();

    await tester.pumpWidget(
      BlocProvider<WalletBloc>(
        create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
        child: MaterialApp(
          theme: AppTheme.dark,
          home: WalletPage(biometricService: biometricService),
        ),
      ),
    );
    await tester.pumpAndSettle();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(biometricService.authenticationCount, 0);
    expect(find.text('Your wallet is empty'), findsOneWidget);
  });

  testWidgets('cancel closes biometric sheet without enabling login', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    final biometricService = _FakeBiometricService();

    await tester.pumpWidget(
      BlocProvider<WalletBloc>(
        create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
        child: MaterialApp(
          theme: AppTheme.dark,
          home: WalletPage(biometricService: biometricService),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('biometric-switch')));
    await tester.pumpAndSettle();
    expect(find.text('Fingerprint login'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Fingerprint login'), findsNothing);
    expect(biometricService.authenticationCount, 0);
    expect(
      tester
          .widget<Switch>(find.byKey(const ValueKey('biometric-switch')))
          .value,
      isFalse,
    );
  });

  testWidgets(
    'does not repeat authentication when the biometric prompt changes lifecycle',
    (WidgetTester tester) async {
      FlutterSecureStorage.setMockInitialValues({});
      final biometricService = _FakeBiometricService(
        authenticationResult: Completer<bool>(),
      );

      await tester.pumpWidget(
        BlocProvider<WalletBloc>(
          create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
          child: MaterialApp(
            theme: AppTheme.dark,
            home: WalletPage(biometricService: biometricService),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('biometric-switch')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Verify'));
      await tester.pump();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();

      expect(biometricService.authenticationCount, 1);

      biometricService.authenticationResult!.complete(true);
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Switch>(find.byKey(const ValueKey('biometric-switch')))
            .value,
        isTrue,
      );
      expect(biometricService.authenticationCount, 1);
    },
  );
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

class _FakeBiometricService extends BiometricService {
  _FakeBiometricService({this.authenticationResult});

  final Completer<bool>? authenticationResult;
  int authenticationCount = 0;

  @override
  Future<bool> authenticate() async {
    authenticationCount++;
    return authenticationResult?.future ?? true;
  }

  @override
  Future<bool> isAvailable() async {
    return true;
  }
}
