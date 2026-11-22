import 'dart:async';

import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_state.dart';
import 'package:crypto_currency/feature/login/presentation/widgets/number.dart';
import 'package:crypto_currency/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginBloc _loginBloc = LoginBloc();

  @override
  void dispose() {
    unawaited(_loginBloc.close());
    super.dispose();
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
      child: BlocListener<LoginBloc, LoginState>(
        bloc: _loginBloc,
        listener: (context, state) {
          if (state.passcode.length == LoginState.passcodeLength) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.wallet);
          }
        },
        child: StreamBuilder<LoginState>(
          stream: _loginBloc.stream,
          initialData: _loginBloc.state,
          builder: (context, snapshot) {
            final state = snapshot.data ?? _loginBloc.state;

            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 74),
                      const _LoginIcon(),
                      const SizedBox(height: 28),
                      Text(
                        'Enter Passcode',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _PasscodeIndicator(passcode: state.passcode),
                      Expanded(child: NumberFiled(loginBloc: _loginBloc)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
