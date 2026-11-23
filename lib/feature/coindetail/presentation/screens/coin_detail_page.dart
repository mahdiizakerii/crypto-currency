import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coindetail/presentation/widgets/coin_detail_chart_card.dart';
import 'package:crypto_currency/feature/coindetail/presentation/widgets/coin_heading.dart';
import 'package:crypto_currency/feature/coindetail/presentation/widgets/coin_information_card.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_bloc.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_event.dart';
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
          CoinHeading(coin: coin),
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
          CoinDetailChartCard(
            selectedDays: _selectedDays,
            onDaysChanged: (days) {
              setState(() => _selectedDays = days);
              _loadChart();
            },
          ),
          const SizedBox(height: 22),
          CoinInformationCard(coin: coin),
        ],
      ),
    );
  }
}
