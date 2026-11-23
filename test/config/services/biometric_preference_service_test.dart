import 'package:crypto_currency/config/services/biometric_preference_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('saves and clears the biometric login preference', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final preference = BiometricPreferenceService();

    expect(await preference.isEnabled(), isFalse);

    await preference.setEnabled(true);
    expect(await BiometricPreferenceService().isEnabled(), isTrue);

    await preference.setEnabled(false);
    expect(await preference.isEnabled(), isFalse);
  });
}
