import 'package:equatable/equatable.dart';

class MarketCoin extends Equatable {
  const MarketCoin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change24h,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String symbol;
  final num price;
  final num change24h;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name, symbol, price, change24h, imageUrl];
}

class CoinPricePoint extends Equatable {
  const CoinPricePoint({required this.time, required this.price});

  final DateTime time;
  final double price;

  @override
  List<Object?> get props => [time, price];
}
