import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/domain/repositories/market_repository.dart';

class GetMarketCoinsUseCase {
  GetMarketCoinsUseCase(this.repository);

  final MarketRepository repository;

  Future<List<MarketCoin>> call() => repository.getCoins();
}
