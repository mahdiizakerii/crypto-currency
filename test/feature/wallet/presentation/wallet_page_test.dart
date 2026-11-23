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

  testWidgets('authenticates again when the app returns to the foreground', (
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

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.text('Unlock wallet'), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(biometricService.authenticationCount, 1);
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

class _FakeBiometricService extends BiometricService {
  int authenticationCount = 0;

  @override
  Future<bool> authenticate() async {
    authenticationCount++;
    return true;
  }
}
