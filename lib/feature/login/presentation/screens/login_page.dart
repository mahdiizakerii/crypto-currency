import 'dart:async';

import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_state.dart';
import 'package:crypto_currency/feature/login/presentation/widgets/number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      child: StreamBuilder<LoginState>(
        stream: _loginBloc.stream,
        initialData: _loginBloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data ?? _loginBloc.state;

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: AppTheme.loginPagePadding,
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.pageTopSpacing),
                    const _LoginIcon(),
                    const SizedBox(height: AppTheme.sectionSpacing),
                    Text(
                      'Enter Passcode',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppTheme.titleBottomSpacing),
                    _PasscodeIndicator(passcode: state.passcode),
                    Expanded(child: NumberFiled(loginBloc: _loginBloc)),
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
      width: AppTheme.iconSize,
      height: AppTheme.iconSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: AppTheme.circleShape,
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        color: Theme.of(context).colorScheme.onPrimary,
        size: AppTheme.iconGlyphSize,
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
            right: index == LoginState.passcodeLength - 1
                ? AppTheme.noSpacing
                : AppTheme.passcodeDotSpacing,
          ),
          child: Semantics(
            label:
                'Digit ${index + 1} ${isEntered ? 'entered' : 'not entered'}',
            child: Container(
              key: ValueKey('passcode-dot-$index'),
              width: AppTheme.passcodeDotSize,
              height: AppTheme.passcodeDotSize,
              decoration: BoxDecoration(
                color: isEntered
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                shape: AppTheme.circleShape,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
