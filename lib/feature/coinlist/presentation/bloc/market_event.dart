abstract class MarketEvent {}

class MarketCoinsRequested extends MarketEvent {}

class MarketChartRequested extends MarketEvent {
  MarketChartRequested({required this.coinId, required this.days});

  final String coinId;
  final int days;
}
