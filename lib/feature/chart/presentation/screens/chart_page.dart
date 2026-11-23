import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/coindetail/presentation/screens/coin_detail_page.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_bloc.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_event.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_state.dart';
import 'package:crypto_currency/feature/coinlist/presentation/widgets/market_coin_icon.dart';
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
                _MarketSummary(coins: state.coins),
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
                    _MarketCoinTile(
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

class _MarketSummary extends StatelessWidget {
  const _MarketSummary({required this.coins});

  final List<MarketCoin> coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.surfaceRaised],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore crypto',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Prices and market trends',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          Text(
            '${coins.length}',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketCoinTile extends StatelessWidget {
  const _MarketCoinTile({required this.coin, required this.onTap});

  final MarketCoin coin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final changeColor = coin.change24h >= 0
        ? AppTheme.positive
        : AppTheme.error;

    return Card(
      color: AppTheme.surface,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: MarketCoinIcon(coin: coin),
        title: Text(
          coin.name,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          coin.symbol,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${coin.price.toStringAsFixed(2)}',
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            Text(
              '${coin.change24h >= 0 ? '+' : ''}${coin.change24h.toStringAsFixed(2)}%',
              style: TextStyle(color: changeColor, fontSize: 12),
            ),
          ],
        ),
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
