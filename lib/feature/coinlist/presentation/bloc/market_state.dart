import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';

class MarketState {
  const MarketState({
    this.coins = const [],
    this.chart = const [],
    this.isLoadingCoins = false,
    this.isLoadingChart = false,
    this.coinsError,
    this.chartError,
  });

  final List<MarketCoin> coins;
  final List<CoinPricePoint> chart;
  final bool isLoadingCoins;
  final bool isLoadingChart;
  final String? coinsError;
  final String? chartError;

  MarketState copyWith({
    List<MarketCoin>? coins,
    List<CoinPricePoint>? chart,
    bool? isLoadingCoins,
    bool? isLoadingChart,
    String? coinsError,
    String? chartError,
    bool clearCoinsError = false,
    bool clearChartError = false,
  }) {
    return MarketState(
      coins: coins ?? this.coins,
      chart: chart ?? this.chart,
      isLoadingCoins: isLoadingCoins ?? this.isLoadingCoins,
      isLoadingChart: isLoadingChart ?? this.isLoadingChart,
      coinsError: clearCoinsError ? null : coinsError ?? this.coinsError,
      chartError: clearChartError ? null : chartError ?? this.chartError,
    );
  }
}
