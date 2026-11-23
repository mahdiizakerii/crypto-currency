import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coindetail/presentation/widgets/price_chart_painter.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_bloc.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinDetailChartCard extends StatelessWidget {
  const CoinDetailChartCard({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
  });

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
