import 'package:bloc/bloc.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_event.dart';
import 'package:crypto_currency/feature/login/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginDigitPressed>((event, emit) {
      if (state.passcode.length >= LoginState.passcodeLength ||
          event.digit.length != 1 ||
          int.tryParse(event.digit) == null) {
        return;
      }

      emit(LoginState(passcode: state.passcode + event.digit));
    });

    on<LoginDeletePressed>((event, emit) {
      if (state.passcode.isEmpty) {
        return;
      }

      emit(
        LoginState(
          passcode: state.passcode.substring(0, state.passcode.length - 1),
        ),
      );
    });
  }
}
