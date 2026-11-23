import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crypto_currency/feature/login/bloc/login_event.dart';
import 'package:crypto_currency/feature/login/bloc/login_state.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/authenticate_biometric.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/check_biometric_availability.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CheckBiometricAvailability checkBiometricAvailability;
  final AuthenticateBiometric authenticateBiometric;
  Timer? _passcodeResetTimer;

  LoginBloc({
    required this.checkBiometricAvailability,
    required this.authenticateBiometric,
  }) : super(const LoginState(biometricStatus: BiometricStatus.unavailable)) {
    on<LoginDigitPressed>((event, emit) {
      if (state.passcode.length >= LoginState.passcodeLength ||
          state.isPasscodeIncorrect ||
          event.digit.length != 1 ||
          int.tryParse(event.digit) == null) {
        return;
      }

      final passcode = state.passcode + event.digit;
      final isIncorrect =
          passcode.length == LoginState.passcodeLength && passcode != '1111';

      emit(
        LoginState(
          passcode: passcode,
          biometricStatus: state.biometricStatus,
          isPasscodeIncorrect: isIncorrect,
        ),
      );

      if (isIncorrect) {
        _passcodeResetTimer?.cancel();
        _passcodeResetTimer = Timer(const Duration(milliseconds: 450), () {
          if (!isClosed) add(LoginPasscodeReset());
        });
      }
    });

    on<LoginDeletePressed>((event, emit) {
      if (state.passcode.isEmpty) return;

      emit(
        LoginState(
          passcode: state.passcode.substring(0, state.passcode.length - 1),
          biometricStatus: state.biometricStatus,
        ),
      );
    });

    on<LoginPasscodeReset>((event, emit) {
      _passcodeResetTimer?.cancel();
      emit(LoginState(biometricStatus: state.biometricStatus));
    });

    on<BiometricAvailabilityRequested>((event, emit) async {
      final available = await checkBiometricAvailability();

      emit(
        LoginState(
          passcode: state.passcode,
          biometricStatus: available
              ? BiometricStatus.available
              : BiometricStatus.unavailable,
        ),
      );
    });

    on<BiometricAuthenticationRequested>((event, emit) async {
      final authenticated = await authenticateBiometric();

      emit(
        LoginState(
          passcode: state.passcode,
          biometricStatus: authenticated
              ? BiometricStatus.authenticated
              : BiometricStatus.failed,
        ),
      );
    });

    on<LoginBiometricAuthenticated>((event, emit) {
      emit(const LoginState(biometricStatus: BiometricStatus.authenticated));
    });
  }

  @override
  Future<void> close() {
    _passcodeResetTimer?.cancel();
    return super.close();
  }
}
