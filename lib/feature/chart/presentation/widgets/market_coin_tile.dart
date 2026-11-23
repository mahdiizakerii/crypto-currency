import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/presentation/widgets/market_coin_icon.dart';
import 'package:flutter/material.dart';

class MarketCoinTile extends StatelessWidget {
  const MarketCoinTile({super.key, required this.coin, required this.onTap});

  final MarketCoin coin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final changeColor = coin.change24h >= 0
        ? AppTheme.positive
        : AppTheme.error;

    return Card(
      color: AppTheme.surface,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: MarketCoinIcon(coin: coin),
        title: Text(
          coin.name,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          coin.symbol,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${coin.price.toStringAsFixed(2)}',
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            Text(
              '${coin.change24h >= 0 ? '+' : ''}${coin.change24h.toStringAsFixed(2)}%',
              style: TextStyle(color: changeColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
