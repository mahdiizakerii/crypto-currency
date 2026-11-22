import 'package:crypto_currency/feature/login/data/data%20source/biometric_local_datasource.dart';
import 'package:crypto_currency/feature/login/domain/repository/biometric_repository.dart';

class BiometricRepositoryImpl implements BiometricRepository {
  final BiometricLocalDataSource localDataSource;

  BiometricRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> isBiometricAvailable() {
    return localDataSource.isBiometricAvailable();
  }

  @override
  Future<bool> authenticate() {
    return localDataSource.authenticate();
  }
}
