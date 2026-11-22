abstract class BiometricRepository {
  Future<bool> isBiometricAvailable();

  Future<bool> authenticate();
}
