import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/chart/presentation/widgets/price_chart_painter.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_bloc.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_event.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_state.dart';
import 'package:crypto_currency/feature/coinlist/presentation/widgets/market_coin_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinDetailPage extends StatefulWidget {
  const CoinDetailPage({super.key, required this.coin});

  final MarketCoin coin;

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  int _selectedDays = 1;

  @override
  void initState() {
    super.initState();
    _loadChart();
  }

  void _loadChart() {
    context.read<MarketBloc>().add(
      MarketChartRequested(coinId: widget.coin.id, days: _selectedDays),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coin = widget.coin;
    final changeColor = coin.change24h >= 0
        ? AppTheme.positive
        : AppTheme.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name),
        centerTitle: true,
        backgroundColor: AppTheme.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _CoinHeading(coin: coin),
          const SizedBox(height: 22),
          Text(
            '\$${coin.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${coin.change24h >= 0 ? '+' : ''}${coin.change24h.toStringAsFixed(2)}% today',
            style: TextStyle(color: changeColor, fontSize: 14),
          ),
          const SizedBox(height: 24),
          _ChartCard(
            selectedDays: _selectedDays,
            onDaysChanged: (days) {
              setState(() => _selectedDays = days);
              _loadChart();
            },
          ),
          const SizedBox(height: 22),
          _CoinInformation(coin: coin),
        ],
      ),
    );
  }
}

class _CoinHeading extends StatelessWidget {
  const _CoinHeading({required this.coin});

  final MarketCoin coin;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MarketCoinIcon(coin: coin, size: 44),
        const SizedBox(width: 12),
        Text(
          coin.symbol,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const Icon(Icons.star_border_rounded, color: AppTheme.textSecondary),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.selectedDays, required this.onDaysChanged});

  final int selectedDays;
  final ValueChanged<int> onDaysChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Price chart',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              for (final period in const {
                1: '1D',
                7: '1W',
                30: '1M',
                365: '1Y',
              }.entries)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: _PeriodButton(
                    label: period.value,
                    selected: selectedDays == period.key,
                    onTap: () => onDaysChanged(period.key),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: BlocBuilder<MarketBloc, MarketState>(
              builder: (context, state) {
                if (state.isLoadingChart) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  );
                }
                if (state.chartError != null) {
                  return Center(
                    child: Text(
                      state.chartError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  );
                }
                if (state.chart.isEmpty) {
                  return const Center(
                    child: Text(
                      'Price history is unavailable',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  );
                }
                return CustomPaint(
                  painter: PriceChartPainter(state.chart),
                  size: Size.infinite,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  const _PeriodButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: selected ? AppTheme.primary : Colors.transparent,
        foregroundColor: selected
            ? AppTheme.textPrimary
            : AppTheme.textSecondary,
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}

class _CoinInformation extends StatelessWidget {
  const _CoinInformation({required this.coin});

  final MarketCoin coin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this asset',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${coin.name} (${coin.symbol}) market price',
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
