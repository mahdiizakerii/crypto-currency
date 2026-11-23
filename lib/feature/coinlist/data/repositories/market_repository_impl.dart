import 'package:crypto_currency/feature/coinlist/data/data_source/market_api_provider.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/domain/repositories/market_repository.dart';

class MarketRepositoryImpl extends MarketRepository {
  MarketRepositoryImpl(this.apiProvider);

  final MarketApiProvider apiProvider;

  @override
  Future<List<MarketCoin>> getCoins() => apiProvider.getCoins();

  @override
  Future<List<CoinPricePoint>> getCoinChart(String id, int days) {
    return apiProvider.getCoinChart(id, days);
  }
}
