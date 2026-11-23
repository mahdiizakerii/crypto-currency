import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CollectiblesEmptyState extends StatelessWidget {
  const CollectiblesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(30),
      child: Text(
        'No collectibles are available.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppTheme.textSecondary),
      ),
    );
  }
}
