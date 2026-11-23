import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:flutter/material.dart';

class MarketCoinIcon extends StatelessWidget {
  const MarketCoinIcon({super.key, required this.coin, this.size = 42});

  final MarketCoin coin;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageUrl = coin.imageUrl;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl == null
            ? _fallback()
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _fallback(),
              ),
      ),
    );
  }

  Widget _fallback() {
    return ColoredBox(
      color: AppTheme.surfaceRaised,
      child: Center(
        child: Text(
          coin.symbol.characters.first,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
