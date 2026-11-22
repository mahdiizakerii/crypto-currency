import 'package:local_auth/local_auth.dart';

abstract class BiometricLocalDataSource {
  Future<bool> isBiometricAvailable();

  Future<bool> authenticate();
}

class BiometricLocalDataSourceImpl implements BiometricLocalDataSource {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<bool> isBiometricAvailable() async {
    final isSupported = await _localAuth.isDeviceSupported();
    final biometrics = await _localAuth.getAvailableBiometrics();

    return isSupported && biometrics.isNotEmpty;
  }

  @override
  Future<bool> authenticate() async {
    return await _localAuth.authenticate(
      localizedReason: 'Authenticate to access your wallet',
      biometricOnly: true,
      persistAcrossBackgrounding: true,
    );
  }
}
