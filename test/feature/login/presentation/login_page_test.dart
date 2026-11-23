import 'package:crypto_currency/config/services/biometric_preference_service.dart';
import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/domain/repository/biometric_repository.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/authenticate_biometric.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/check_biometric_availability.dart';
import 'package:crypto_currency/feature/login/pressentation/login_page.dart';
import 'package:crypto_currency/feature/login/pressentation/widgets/bottom_sheet_biometric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('fingerprint sheet uses a white surface and dark action text', (
    WidgetTester tester,
  ) async {
    late Future<bool> confirmation;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                confirmation = FingerprintBottomSheet.show(
                  context,
                  biometricService: BiometricService(),
                );
              },
              child: const Text('Open fingerprint sheet'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open fingerprint sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Verify'), findsOneWidget);
    final cancel = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Cancel'),
    );
    final verify = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Verify'),
    );
    expect(cancel.style?.foregroundColor?.resolve({}), Colors.grey.shade900);
    expect(verify.style?.foregroundColor?.resolve({}), Colors.grey.shade900);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color == Colors.white,
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await confirmation, isFalse);
  });

  testWidgets('disabled fingerprint login shows enable prompt', (
    WidgetTester tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    final biometricRepository = _FakeBiometricRepository(isAvailable: true);

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BiometricService>.value(value: BiometricService()),
          RepositoryProvider<BiometricPreferenceService>.value(
            value: BiometricPreferenceService(),
          ),
        ],
        child: BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            checkBiometricAvailability: CheckBiometricAvailability(
              biometricRepository,
            ),
            authenticateBiometric: AuthenticateBiometric(biometricRepository),
          ),
          child: const MaterialApp(home: LoginPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('login-biometric-switch')), findsNothing);
    await tester.tap(find.byTooltip('Authenticate with biometrics'));
    await tester.pump();

    expect(find.text('Please enable fingerprint login first.'), findsOneWidget);
  });

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
  _FakeBiometricRepository({this.isAvailable = false});

  final bool isAvailable;

  @override
  Future<bool> authenticate() async => false;

  @override
  Future<bool> isBiometricAvailable() async => isAvailable;
}
