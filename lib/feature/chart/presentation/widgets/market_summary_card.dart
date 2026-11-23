import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:flutter/material.dart';

class MarketSummaryCard extends StatelessWidget {
  const MarketSummaryCard({super.key, required this.coins});

  final List<MarketCoin> coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.surfaceRaised],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore crypto',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Prices and market trends',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          Text(
            '${coins.length}',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
