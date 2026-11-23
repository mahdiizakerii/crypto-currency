import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';
import 'package:crypto_currency/feature/collectibles/presentation/widgets/collectible_details_sheet.dart';
import 'package:crypto_currency/feature/collectibles/presentation/widgets/collectible_placeholder.dart';
import 'package:flutter/material.dart';

class CollectibleCard extends StatelessWidget {
  const CollectibleCard({super.key, required this.item});

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
          builder: (_) => CollectibleDetailsSheet(item: item),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: item.imageUrl == null
                    ? const CollectiblePlaceholder()
                    : Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const CollectiblePlaceholder(),
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
