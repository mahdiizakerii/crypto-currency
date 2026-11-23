import 'package:crypto_currency/feature/news/domain/entities/news_item.dart';
import 'package:crypto_currency/feature/news/domain/repositories/news_repository.dart';

class GetNewsUseCase {
  GetNewsUseCase(this.repository);

  final NewsRepository repository;

  Future<List<NewsItem>> call() => repository.getNews();
}
