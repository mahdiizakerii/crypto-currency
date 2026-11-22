import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Chart is coming soon',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}
