import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CollectiblesPage extends StatelessWidget {
  const CollectiblesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Collectibles is coming soon',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}
