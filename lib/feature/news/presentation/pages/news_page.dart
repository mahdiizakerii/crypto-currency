import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'News is coming soon',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}
