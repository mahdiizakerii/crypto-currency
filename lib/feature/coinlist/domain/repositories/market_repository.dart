import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';

abstract class MarketRepository {
  Future<List<MarketCoin>> getCoins();

  Future<List<CoinPricePoint>> getCoinChart(String id, int days);
}
