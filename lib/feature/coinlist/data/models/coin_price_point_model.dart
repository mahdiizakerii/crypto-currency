import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';

class CoinPricePointModel extends CoinPricePoint {
  const CoinPricePointModel({required super.time, required super.price});

  static List<CoinPricePoint> fromJson(Map<String, dynamic> json) {
    final timestamps = json['t'];
    final closingPrices = json['c'];

    if (timestamps is! List || closingPrices is! List) {
      throw const FormatException('Chart response is missing price data.');
    }

    final length = timestamps.length < closingPrices.length
        ? timestamps.length
        : closingPrices.length;
    final points = <CoinPricePoint>[];

    for (var index = 0; index < length; index++) {
      final timestamp = timestamps[index];
      final price = closingPrices[index];
      if (timestamp is! num || price is! num) continue;

      points.add(
        CoinPricePointModel(
          time: DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000),
          price: price.toDouble(),
        ),
      );
    }

    if (points.isEmpty) {
      throw const FormatException('Chart response contains no price points.');
    }
    return List.unmodifiable(points);
  }
}
