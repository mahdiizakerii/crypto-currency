import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';
import 'package:crypto_currency/feature/collectibles/presentation/bloc/collectibles_bloc.dart';
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
                  _CollectiblesError(message: state.error!, onRetry: _refresh)
                else if (state.items.isEmpty)
                  const _EmptyCollectibles()
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
                        _CollectibleCard(item: state.items[index]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CollectibleCard extends StatelessWidget {
  const _CollectibleCard({required this.item});

  final Collectible item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          backgroundColor: AppTheme.surface,
          builder: (_) => _CollectibleDetails(item: item),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: item.imageUrl == null
                    ? const _CollectiblePlaceholder()
                    : Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const _CollectiblePlaceholder(),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bid  ${item.bid} ${item.currency}',
                    style: const TextStyle(
                      color: AppTheme.positive,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectibleDetails extends StatelessWidget {
  const _CollectibleDetails({required this.item});

  final Collectible item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${item.artist}  ·  ${item.category}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              style: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Current bid: ${item.bid} ${item.currency}',
              style: const TextStyle(color: AppTheme.positive),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectiblePlaceholder extends StatelessWidget {
  const _CollectiblePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppTheme.surfaceRaised,
      child: Center(
        child: Icon(Icons.diamond_outlined, color: AppTheme.textSecondary),
      ),
    );
  }
}

class _CollectiblesError extends StatelessWidget {
  const _CollectiblesError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.cloud_off_rounded, color: AppTheme.textSecondary),
        const SizedBox(height: 8),
        Text(message, style: const TextStyle(color: AppTheme.textSecondary)),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}

class _EmptyCollectibles extends StatelessWidget {
  const _EmptyCollectibles();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(30),
      child: Text(
        'No collectibles are available.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppTheme.textSecondary),
      ),
    );
  }
}
