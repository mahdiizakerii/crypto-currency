import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/domain/repositories/market_repository.dart';

class GetCoinChartUseCase {
  GetCoinChartUseCase(this.repository);

  final MarketRepository repository;

  Future<List<CoinPricePoint>> call(String id, int days) {
    return repository.getCoinChart(id, days);
  }
}
