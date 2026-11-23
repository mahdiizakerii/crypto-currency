import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class FingerprintBottomSheet {
  static Future<bool> show(
    BuildContext context, {
    BiometricService? biometricService,
    ValueChanged<bool>? onAuthenticationChanged,
  }) async {
    final service = biometricService ?? BiometricService();
    var isVerifying = false;

    return await showModalBottomSheet<bool>(
          context: context,
          isDismissible: true,
          enableDrag: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (sheetContext) {
            return StatefulBuilder(
              builder: (context, setSheetState) {
                return SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
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
                                onPressed: () =>
                                    Navigator.pop(sheetContext, false),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey.shade900,
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isVerifying
                                    ? null
                                    : () async {
                                        setSheetState(() {
                                          isVerifying = true;
                                        });
                                        onAuthenticationChanged?.call(true);
                                        try {
                                          final success = await service
                                              .authenticate();
                                          if (sheetContext.mounted) {
                                            Navigator.pop(
                                              sheetContext,
                                              success,
                                            );
                                          }
                                        } finally {
                                          onAuthenticationChanged?.call(false);
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
            );
          },
        ) ??
        false;
  }
}
