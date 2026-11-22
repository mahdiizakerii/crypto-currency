abstract class LoginEvent {}

class LoginDigitPressed extends LoginEvent {
  LoginDigitPressed(this.digit);

  final String digit;
}

class LoginDeletePressed extends LoginEvent {}
