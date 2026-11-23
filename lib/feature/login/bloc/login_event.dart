abstract class LoginEvent {}

class LoginDigitPressed extends LoginEvent {
  LoginDigitPressed(this.digit);

  final String digit;
}

class LoginDeletePressed extends LoginEvent {}

class LoginPasscodeReset extends LoginEvent {}

class BiometricAvailabilityRequested extends LoginEvent {}

class BiometricAuthenticationRequested extends LoginEvent {}

class LoginBiometricAuthenticated extends LoginEvent {}
