import 'package:bloc/bloc.dart';
import 'package:crypto_currency/feature/coinlist/domain/use_cases/get_coin_chart_use_case.dart';
import 'package:crypto_currency/feature/coinlist/domain/use_cases/get_market_coins_use_case.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_event.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc({required this.getMarketCoins, required this.getCoinChart})
    : super(const MarketState()) {
    on<MarketCoinsRequested>(_onCoinsRequested);
    on<MarketChartRequested>(_onChartRequested);
  }

  final GetMarketCoinsUseCase getMarketCoins;
  final GetCoinChartUseCase getCoinChart;

  Future<void> _onCoinsRequested(
    MarketCoinsRequested event,
    Emitter<MarketState> emit,
  ) async {
    emit(state.copyWith(isLoadingCoins: true, clearCoinsError: true));
    try {
      final coins = await getMarketCoins();
      emit(state.copyWith(coins: coins, isLoadingCoins: false));
    } catch (error) {
      emit(state.copyWith(isLoadingCoins: false, coinsError: error.toString()));
    }
  }

  Future<void> _onChartRequested(
    MarketChartRequested event,
    Emitter<MarketState> emit,
  ) async {
    emit(state.copyWith(isLoadingChart: true, clearChartError: true));
    try {
      final points = await getCoinChart(event.coinId, event.days);
      emit(state.copyWith(chart: points, isLoadingChart: false));
    } catch (error) {
      emit(state.copyWith(isLoadingChart: false, chartError: error.toString()));
    }
  }
}
