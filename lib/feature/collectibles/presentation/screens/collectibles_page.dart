import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/collectibles/presentation/bloc/collectibles_bloc.dart';
import 'package:crypto_currency/feature/collectibles/presentation/widgets/collectible_card.dart';
import 'package:crypto_currency/feature/collectibles/presentation/widgets/collectibles_empty_state.dart';
import 'package:crypto_currency/feature/collectibles/presentation/widgets/collectibles_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectiblesPage extends StatefulWidget {
  const CollectiblesPage({super.key});

  @override
  State<CollectiblesPage> createState() => _CollectiblesPageState();
}

class _CollectiblesPageState extends State<CollectiblesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CollectiblesBloc>().add(CollectiblesRequested());
  }

  Future<void> _refresh() async {
    final bloc = context.read<CollectiblesBloc>();
    final loaded = bloc.stream.firstWhere((state) => !state.isLoading);
    bloc.add(CollectiblesRequested());
    await loaded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collectibles'),
        backgroundColor: AppTheme.background,
      ),
      body: BlocBuilder<CollectiblesBloc, CollectiblesState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _refresh,
            color: AppTheme.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const Text(
                  'Your digital collection',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Discover unique items from across the network',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 18),
                if (state.isLoading && state.items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    ),
                  )
                else if (state.error != null && state.items.isEmpty)
                  CollectiblesErrorView(
                    message: state.error!,
                    onRetry: _refresh,
                  )
                else if (state.items.isEmpty)
                  const CollectiblesEmptyState()
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                    itemBuilder: (context, index) =>
                        CollectibleCard(item: state.items[index]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
