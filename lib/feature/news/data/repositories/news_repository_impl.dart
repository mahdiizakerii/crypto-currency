import 'package:crypto_currency/feature/news/data/data_source/news_api_provider.dart';
import 'package:crypto_currency/feature/news/domain/entities/news_item.dart';
import 'package:crypto_currency/feature/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl extends NewsRepository {
  NewsRepositoryImpl(this.apiProvider);

  final NewsApiProvider apiProvider;

  @override
  Future<List<NewsItem>> getNews() => apiProvider.getNews();
}
