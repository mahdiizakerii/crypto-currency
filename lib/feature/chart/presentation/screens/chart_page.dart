import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/chart/presentation/widgets/market_coin_tile.dart';
import 'package:crypto_currency/feature/chart/presentation/widgets/market_summary_card.dart';
import 'package:crypto_currency/feature/coindetail/presentation/screens/coin_detail_page.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_bloc.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_event.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    context.read<MarketBloc>().add(MarketCoinsRequested());
  }

  Future<void> _refresh() async {
    final bloc = context.read<MarketBloc>();
    final loaded = bloc.stream.firstWhere((state) => !state.isLoadingCoins);
    bloc.add(MarketCoinsRequested());
    await loaded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        backgroundColor: AppTheme.background,
      ),
      body: BlocBuilder<MarketBloc, MarketState>(
        builder: (context, state) {
          final coins = state.coins.where((coin) {
            final query = _search.toLowerCase();
            return coin.name.toLowerCase().contains(query) ||
                coin.symbol.toLowerCase().contains(query);
          }).toList();

          return RefreshIndicator(
            onRefresh: _refresh,
            color: AppTheme.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                MarketSummaryCard(coins: state.coins),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => setState(() => _search = value.trim()),
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search coins',
                    hintStyle: const TextStyle(color: AppTheme.textSecondary),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTheme.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppTheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Top assets',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                if (state.isLoadingCoins && state.coins.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    ),
                  )
                else if (state.coinsError != null && state.coins.isEmpty)
                  _MarketError(message: state.coinsError!, onRetry: _refresh)
                else if (coins.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No matching assets',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                else
                  for (final coin in coins)
                    MarketCoinTile(
                      coin: coin,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CoinDetailPage(coin: coin),
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MarketError extends StatelessWidget {
  const _MarketError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, color: AppTheme.textSecondary),
          const SizedBox(height: 8),
          Text(
            'Could not load market data',
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
