import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class FingerprintBottomSheet {
  static Future<bool> show(BuildContext context) async {
    return await showModalBottomSheet<bool>(
          context: context,
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.fingerprint,
                    size: 85,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Fingerprint login',
                    style: TextStyle(color: AppTheme.textPrimary, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Verify your fingerprint to log in',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await BiometricService()
                                .authenticate();

                            if (context.mounted) {
                              Navigator.pop(context, success);
                            }
                          },
                          child: const Text('Verify fingerprint'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }
}
