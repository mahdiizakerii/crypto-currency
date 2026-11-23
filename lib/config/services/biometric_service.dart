import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    final supported = await _auth.isDeviceSupported();
    final biometrics = await _auth.getAvailableBiometrics();

    return supported && biometrics.isNotEmpty;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason:
            WidgetsBinding.instance.platformDispatcher.locale.languageCode ==
                'fa'
            ? 'برای ورود به کیف پول، اثر انگشت خود را تأیید کنید'
            : 'Verify your fingerprint to enter the wallet',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
