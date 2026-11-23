import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/domain/repository/biometric_repository.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/authenticate_biometric.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/check_biometric_availability.dart';
import 'package:crypto_currency/feature/login/pressentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('wrong passcode turns red then clears without a snackbar', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final biometricRepository = _FakeBiometricRepository();

    await tester.pumpWidget(
      BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(
          checkBiometricAvailability: CheckBiometricAvailability(
            biometricRepository,
          ),
          authenticateBiometric: AuthenticateBiometric(biometricRepository),
        ),
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    for (final digit in ['1', '2', '3', '4']) {
      await tester.tap(find.byKey(ValueKey('digit-$digit')));
      await tester.pump();
    }

    final firstDot = tester.widget<Container>(
      find.byKey(const ValueKey('passcode-dot-0')),
    );
    expect(firstDot.decoration, isA<BoxDecoration>());
    expect((firstDot.decoration! as BoxDecoration).color, AppTheme.error);
    expect(find.byType(SnackBar), findsNothing);

    await tester.pump(const Duration(milliseconds: 500));

    final clearedDot = tester.widget<Container>(
      find.byKey(const ValueKey('passcode-dot-0')),
    );
    expect((clearedDot.decoration! as BoxDecoration).color, AppTheme.surface);
    expect(find.byType(SnackBar), findsNothing);
  });
}

class _FakeBiometricRepository implements BiometricRepository {
  @override
  Future<bool> authenticate() async => false;

  @override
  Future<bool> isBiometricAvailable() async => false;
}
