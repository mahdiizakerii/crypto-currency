import 'dart:async';
import 'dart:math' as math;

import 'package:crypto_currency/core/utils/app_router.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_event.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_state.dart';
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
    const backgroundColor = Color(0xFF080D3B);

    return BlocListener<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state.passcode.length == LoginState.passcodeLength) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.wallet);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                                  child: _NumberPad(loginBloc: _loginBloc),
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

class _NumberPad extends StatelessWidget {
  const _NumberPad({required this.loginBloc});

  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisSpacing = 24.0;
        const mainAxisSpacing = 16.0;
        final cellWidth = (constraints.maxWidth - 2 * crossAxisSpacing) / 3;
        final cellHeight = (constraints.maxHeight - 3 * mainAxisSpacing) / 4;

        return GridView.count(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: cellWidth / cellHeight,
          children: [
            for (var digit = 1; digit <= 9; digit++)
              _numberButton(digit.toString()),
            const SizedBox.shrink(),
            _numberButton('0'),
            _deleteButton(),
          ],
        );
      },
    );
  }

  Widget _numberButton(String digit) {
    return _KeyButton(
      key: ValueKey('digit-$digit'),
      label: 'Digit $digit',
      onPressed: () => loginBloc.add(LoginDigitPressed(digit)),
      child: Text(
        digit,
        style: const TextStyle(
          color: Color(0xFFF7F7FF),
          fontSize: 32,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return _KeyButton(
      key: const ValueKey('delete-digit'),
      label: 'Delete last digit',
      onPressed: () => loginBloc.add(LoginDeletePressed()),
      child: const Icon(Icons.backspace_rounded, color: Colors.white, size: 27),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.child,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: const Color(0xFF10154C),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}
