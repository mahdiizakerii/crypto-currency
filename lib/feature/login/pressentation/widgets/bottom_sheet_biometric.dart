import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class FingerprintBottomSheet {
  static Future<bool> show(BuildContext context) async {
    return await showModalBottomSheet<bool>(
          context: context,
          isDismissible: true,
          enableDrag: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Verify your fingerprint to log in',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade900,
                            ),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey.shade900,
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: const Text('Verify'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }
}
