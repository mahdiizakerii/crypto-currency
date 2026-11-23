import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';
import 'package:flutter/material.dart';

class CollectibleDetailsSheet extends StatelessWidget {
  const CollectibleDetailsSheet({super.key, required this.item});

  final Collectible item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${item.artist}  ·  ${item.category}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              style: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Current bid: ${item.bid} ${item.currency}',
              style: const TextStyle(color: AppTheme.positive),
            ),
          ],
        ),
      ),
    );
  }
}
