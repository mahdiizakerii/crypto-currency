import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/presentation/widgets/market_coin_icon.dart';
import 'package:flutter/material.dart';

class CoinHeading extends StatelessWidget {
  const CoinHeading({super.key, required this.coin});

  final MarketCoin coin;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MarketCoinIcon(coin: coin, size: 44),
        const SizedBox(width: 12),
        Text(
          coin.symbol,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const Icon(Icons.star_border_rounded, color: AppTheme.textSecondary),
      ],
    );
  }
}
