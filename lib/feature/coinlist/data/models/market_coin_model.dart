import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';

class MarketCoinModel extends MarketCoin {
  const MarketCoinModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.price,
    required super.change24h,
    super.imageUrl,
  });

  factory MarketCoinModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final symbol = json['symbol'];
    final price = json['current_price'];
    final change24h = json['price_change_percentage_24h'] ?? 0;
    final image = json['image'];

    if (id == null || name is! String || symbol is! String || price is! num) {
      throw const FormatException('Coin data is missing required values.');
    }
    if (change24h is! num) {
      throw const FormatException('Coin price change must be a number.');
    }
    if (image != null && image is! String) {
      throw const FormatException('Coin image must be a string or null.');
    }

    return MarketCoinModel(
      id: id.toString(),
      name: name,
      symbol: symbol,
      price: price,
      change24h: change24h,
      imageUrl: image as String?,
    );
  }
}
