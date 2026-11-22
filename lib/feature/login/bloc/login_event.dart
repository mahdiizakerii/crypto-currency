abstract class LoginEvent {}

class LoginDigitPressed extends LoginEvent {
  LoginDigitPressed(this.digit);

  final String digit;
}

class LoginDeletePressed extends LoginEvent {}

class BiometricAvailabilityRequested extends LoginEvent {}

class BiometricAuthenticationRequested extends LoginEvent {}
