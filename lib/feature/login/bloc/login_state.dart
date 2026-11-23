class LoginState {
  const LoginState({
    this.passcode = '',
    this.biometricStatus = BiometricStatus.initial,
    this.isPasscodeIncorrect = false,
  });

  static const passcodeLength = 4;

  final String passcode;
  final BiometricStatus biometricStatus;
  final bool isPasscodeIncorrect;
}

enum BiometricStatus { initial, available, unavailable, authenticated, failed }
