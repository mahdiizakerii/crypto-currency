import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:flutter/material.dart';

class CoinInformationCard extends StatelessWidget {
  const CoinInformationCard({super.key, required this.coin});

  final MarketCoin coin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this asset',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${coin.name} (${coin.symbol}) market price',
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
