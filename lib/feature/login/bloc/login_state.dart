class LoginState {
  const LoginState({
    this.passcode = '',
    this.biometricStatus = BiometricStatus.initial,
  });

  static const passcodeLength = 4;

  final String passcode;
  final BiometricStatus biometricStatus;
}

enum BiometricStatus { initial, available, unavailable, authenticated, failed }
