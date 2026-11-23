import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/news/domain/entities/news_item.dart';
import 'package:crypto_currency/feature/news/presentation/widgets/category_item.dart';
import 'package:crypto_currency/feature/news/presentation/widgets/news_details.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.item, required this.featured});

  final NewsItem item;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.surface,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppTheme.surface,
          builder: (_) => NewsDetails(item: item),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null)
              Image.network(
                item.imageUrl!,
                width: double.infinity,
                height: featured ? 190 : 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const _NewsImage(),
              )
            else
              const _NewsImage(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CategoryChip(label: item.category),
                      if (item.isHot) ...[
                        const SizedBox(width: 8),
                        const CategoryChip(label: 'HOT'),
                      ],
                      const Spacer(),
                      Text(
                        item.timeAgo,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    maxLines: featured ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.source,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
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

class _NewsImage extends StatelessWidget {
  const _NewsImage();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 150,
      width: double.infinity,
      child: ColoredBox(
        color: AppTheme.surfaceRaised,
        child: Icon(Icons.article_outlined, color: AppTheme.textSecondary),
      ),
    );
  }
}
