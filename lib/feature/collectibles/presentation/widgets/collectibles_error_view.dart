import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CollectiblesErrorView extends StatelessWidget {
  const CollectiblesErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.cloud_off_rounded, color: AppTheme.textSecondary),
        const SizedBox(height: 8),
        Text(message, style: const TextStyle(color: AppTheme.textSecondary)),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}
