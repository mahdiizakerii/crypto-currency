import 'package:crypto_currency/feature/login/presentation/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_event.dart';
import 'package:crypto_currency/feature/login/presentation/widgets/key_button.dart';
import 'package:flutter/material.dart';

class NumberFiled extends StatelessWidget {
  const NumberFiled({super.key, required this.loginBloc});

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
    return KeyButton(
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
    return KeyButton(
      key: const ValueKey('delete-digit'),
      label: 'Delete last digit',
      onPressed: () => loginBloc.add(LoginDeletePressed()),
      child: const Icon(Icons.backspace_rounded, color: Colors.white, size: 27),
    );
  }
}
