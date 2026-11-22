import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/domain/repository/biometric_repository.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/authenticate_biometric.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/check_biometric_availability.dart';
import 'package:crypto_currency/routes/app_routes.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('four-digit passcode opens the wallet route', (
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
                WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
          ),
          BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(
              checkBiometricAvailability: CheckBiometricAvailability(
                _FakeBiometricRepository(),
              ),
              authenticateBiometric: AuthenticateBiometric(
                _FakeBiometricRepository(),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoutes.login,
          routes: AppRoutes.routes,
        ),
      ),
    );

    for (final digit in ['1', '1', '1', '1']) {
      await tester.tap(find.byKey(ValueKey('digit-$digit')));
      await tester.pump();
    }

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Your wallet is empty'), findsOneWidget);
  });
}

class _FakeBiometricRepository implements BiometricRepository {
  @override
  Future<bool> authenticate() async => false;

  @override
  Future<bool> isBiometricAvailable() async => false;
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
