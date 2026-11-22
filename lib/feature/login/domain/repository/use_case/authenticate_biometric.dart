import 'package:crypto_currency/feature/login/domain/repository/biometric_repository.dart';

class AuthenticateBiometric {
  final BiometricRepository repository;

  AuthenticateBiometric(this.repository);

  Future<bool> call() {
    return repository.authenticate();
  }
}
