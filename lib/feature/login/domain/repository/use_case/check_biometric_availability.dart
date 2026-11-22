import 'package:crypto_currency/feature/login/domain/repository/biometric_repository.dart';

class CheckBiometricAvailability {
  final BiometricRepository repository;

  CheckBiometricAvailability(this.repository);

  Future<bool> call() {
    return repository.isBiometricAvailable();
  }
}
