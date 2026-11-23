import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:flutter/material.dart';

class PriceChartPainter extends CustomPainter {
  const PriceChartPainter(this.points);

  final List<CoinPricePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final prices = points.map((point) => point.price).toList();
    final minimum = prices.reduce((a, b) => a < b ? a : b);
    final maximum = prices.reduce((a, b) => a > b ? a : b);
    final range = maximum - minimum;
    final safeRange = range == 0 ? 1 : range;
    final lineColor = prices.last >= prices.first
        ? AppTheme.positive
        : AppTheme.error;
    final line = Path();

    for (var index = 0; index < prices.length; index++) {
      final x = size.width * index / (prices.length - 1);
      final y =
          size.height - ((prices[index] - minimum) / safeRange) * size.height;
      if (index == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }

    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          colors: [lineColor.withValues(alpha: 0.25), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant PriceChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
