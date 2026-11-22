import 'package:bloc/bloc.dart';
import 'package:crypto_currency/feature/login/bloc/login_event.dart';
import 'package:crypto_currency/feature/login/bloc/login_state.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/authenticate_biometric.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/check_biometric_availability.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CheckBiometricAvailability checkBiometricAvailability;
  final AuthenticateBiometric authenticateBiometric;

  LoginBloc({
    required this.checkBiometricAvailability,
    required this.authenticateBiometric,
  }) : super(
         const LoginState(biometricStatus: BiometricStatus.unavailable),
       ) {
    on<LoginDigitPressed>((event, emit) {
      if (state.passcode.length >= LoginState.passcodeLength ||
          event.digit.length != 1 ||
          int.tryParse(event.digit) == null) {
        return;
      }

      emit(
        LoginState(
          passcode: state.passcode + event.digit,
          biometricStatus: state.biometricStatus,
        ),
      );
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
  }
}
