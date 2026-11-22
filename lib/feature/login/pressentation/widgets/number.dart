import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/bloc/login_event.dart';
import 'package:crypto_currency/feature/login/pressentation/widgets/key_button.dart';
import 'package:flutter/material.dart';

class NumberFiled extends StatelessWidget {
  const NumberFiled({super.key, required this.loginBloc});

  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 24,
      mainAxisSpacing: 16,
      children: [
        for (var digit = 1; digit <= 9; digit++)
          _numberButton(digit.toString()),
        const SizedBox.shrink(),
        _numberButton('0'),
        _deleteButton(),
      ],
    );
  }

  Widget _numberButton(String digit) {
    return KeyButton(
      key: ValueKey('digit-$digit'),
      label: 'Digit $digit',
      onPressed: () => loginBloc.add(LoginDigitPressed(digit)),
      child: Text(
        digit,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return KeyButton(
      key: const ValueKey('delete-digit'),
      label: 'Delete last digit',
      onPressed: () => loginBloc.add(LoginDeletePressed()),
      child: Icon(
        Icons.backspace_rounded,
        color: AppTheme.textPrimary,
        size: 27,
      ),
    );
  }
}
