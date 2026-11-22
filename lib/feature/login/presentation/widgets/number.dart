import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_event.dart';
import 'package:crypto_currency/feature/login/presentation/widgets/key_button.dart';
import 'package:flutter/material.dart';

class NumberFiled extends StatelessWidget {
  const NumberFiled({super.key, required this.loginBloc});

  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: AppTheme.noPadding,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: AppTheme.keypadColumns,
      crossAxisSpacing: AppTheme.keypadColumnSpacing,
      mainAxisSpacing: AppTheme.keypadRowSpacing,
      childAspectRatio: AppTheme.keypadCellAspectRatio,
      children: [
        for (var digit = 1; digit <= 9; digit++)
          _numberButton(context, digit.toString()),
        const SizedBox.shrink(),
        _numberButton(context, '0'),
        _deleteButton(context),
      ],
    );
  }

  Widget _numberButton(BuildContext context, String digit) {
    return KeyButton(
      key: ValueKey('digit-$digit'),
      label: 'Digit $digit',
      onPressed: () => loginBloc.add(LoginDigitPressed(digit)),
      child: Text(digit, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return KeyButton(
      key: const ValueKey('delete-digit'),
      label: 'Delete last digit',
      onPressed: () => loginBloc.add(LoginDeletePressed()),
      child: Icon(
        Icons.backspace_rounded,
        color: Theme.of(context).colorScheme.onSurface,
        size: AppTheme.deleteIconSize,
      ),
    );
  }
}
