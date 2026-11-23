import 'package:crypto_currency/feature/news/domain/entities/news_item.dart';

abstract class NewsRepository {
  Future<List<NewsItem>> getNews();
}
