import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CollectiblePlaceholder extends StatelessWidget {
  const CollectiblePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppTheme.surfaceRaised,
      child: Center(
        child: Icon(Icons.diamond_outlined, color: AppTheme.textSecondary),
      ),
    );
  }
}
