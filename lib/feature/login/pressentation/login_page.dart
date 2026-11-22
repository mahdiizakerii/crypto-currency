import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/bloc/login_event.dart';
import 'package:crypto_currency/feature/login/bloc/login_state.dart';
import 'package:crypto_currency/feature/login/pressentation/widgets/number.dart';
import 'package:crypto_currency/feature/wallet/presentation/pages/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    context.read<LoginBloc>().add(BiometricAvailabilityRequested());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppTheme.statusBarColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.passcode == '1111' ||
              state.biometricStatus == BiometricStatus.authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WalletPage()),
            );
          } else if (state.passcode.length == 4) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Incorrect passcode. Please try again.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state.biometricStatus == BiometricStatus.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Biometric authentication failed')),
            );
          }
        },

        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 28),
                child: Column(
                  children: [
                    const SizedBox(height: 74),
                    const _LoginIcon(),
                    const SizedBox(height: 28),
                    const Text(
                      'Enter Passcode',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _PasscodeIndicator(passcode: state.passcode),
                    if (state.biometricStatus == BiometricStatus.available) ...[
                      const SizedBox(height: 30),
                      IconButton(
                        onPressed: () {
                          context.read<LoginBloc>().add(
                            BiometricAuthenticationRequested(),
                          );
                        },
                        icon: const Icon(
                          Icons.fingerprint,
                          size: 48,
                          color: AppTheme.primary,
                        ),
                        tooltip: 'Authenticate with biometrics',
                      ),
                    ],
                    Expanded(
                      child: NumberFiled(loginBloc: context.read<LoginBloc>()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoginIcon extends StatelessWidget {
  const _LoginIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        color: AppTheme.textPrimary,
        size: 23,
      ),
    );
  }
}

class _PasscodeIndicator extends StatelessWidget {
  const _PasscodeIndicator({required this.passcode});

  final String passcode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(LoginState.passcodeLength, (index) {
        final isEntered = index < passcode.length;

        return Padding(
          padding: EdgeInsets.only(
            right: index == LoginState.passcodeLength - 1 ? 0 : 16,
          ),
          child: Semantics(
            label:
                'Digit ${index + 1} ${isEntered ? 'entered' : 'not entered'}',
            child: Container(
              key: ValueKey('passcode-dot-$index'),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isEntered ? AppTheme.primary : AppTheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.border),
              ),
            ),
          ),
        );
      }),
    );
  }
}
