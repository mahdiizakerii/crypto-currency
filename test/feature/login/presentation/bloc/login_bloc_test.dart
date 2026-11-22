import 'package:crypto_currency/feature/login/presentation/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts four digits and ignores extra digits', () async {
    final bloc = LoginBloc();

    for (final digit in ['1', '2', '3', '4']) {
      final nextState = bloc.stream.first;
      bloc.add(LoginDigitPressed(digit));
      await nextState;
    }

    bloc.add(LoginDigitPressed('5'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.passcode, '1234');
    await bloc.close();
  });
}
