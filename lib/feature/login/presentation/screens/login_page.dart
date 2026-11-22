import 'dart:async';
import 'dart:math' as math;

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
    const backgroundColor = Color(0xFF080D3B);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: backgroundColor,
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
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 28),
                child: Column(
                  children: [
                    const SizedBox(height: 74),
                    const _LoginIcon(),
                    const SizedBox(height: 28),
                    const Text(
                      'Enter Passcode',
                      style: TextStyle(
                        color: Color(0xFFF7F7FF),
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _PasscodeIndicator(passcode: state.passcode),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final padHeight = math.min(
                            constraints.maxHeight,
                            420.0,
                          );

                          return Column(
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: padHeight,
                                child: NumberFiled(loginBloc: _loginBloc),
                              ),
                            ],
                          );
                        },
                      ),
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
        color: Color(0xFF304BFF),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        color: Colors.white,
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
                color: isEntered
                    ? const Color(0xFF304BFF)
                    : const Color(0xFF10154C),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF263FC6)),
              ),
            ),
          ),
        );
      }),
    );
  }
}
