import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricPreferenceService {
  static const String _key = 'biometric_login_enabled';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> isEnabled() async {
    final value = await _storage.read(key: _key);
    return value == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    if (enabled) {
      await _storage.write(key: _key, value: 'true');
    } else {
      await _storage.delete(key: _key);
    }
  }
}
