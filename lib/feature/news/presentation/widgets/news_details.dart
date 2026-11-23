import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/news/domain/entities/news_item.dart';
import 'package:crypto_currency/feature/news/presentation/widgets/category_item.dart';
import 'package:flutter/widgets.dart';

class NewsDetails extends StatelessWidget {
  const NewsDetails({super.key, required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryChip(label: item.category),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${item.source}  ·  ${item.timeAgo}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 18),
            Text(
              item.summary,
              style: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
