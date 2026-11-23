import 'package:crypto_currency/config/services/biometric_service.dart';

abstract class BiometricLocalDataSource {
  Future<bool> isBiometricAvailable();

  Future<bool> authenticate();
}

class BiometricLocalDataSourceImpl implements BiometricLocalDataSource {
  BiometricLocalDataSourceImpl({required this.biometricService});

  final BiometricService biometricService;

  @override
  Future<bool> isBiometricAvailable() {
    return biometricService.isAvailable();
  }

  @override
  Future<bool> authenticate() {
    return biometricService.authenticate();
  }
}
