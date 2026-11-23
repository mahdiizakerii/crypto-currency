import 'package:crypto_currency/core/utils/constants.dart';
import 'package:crypto_currency/feature/news/data/models/news_item_model.dart';
import 'package:crypto_currency/feature/news/domain/entities/news_item.dart';
import 'package:dio/dio.dart';

class NewsApiProvider {
  NewsApiProvider({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<NewsItem>> getNews() async {
    final response = await _dio.get(
      Constants.walletBaseUrl,
      queryParameters: const {'method': 'news', 'limit': 30},
    );
    final body = response.data;
    if (body is! Map || body['success'] != true || body['data'] is! List) {
      throw const FormatException('News response data is invalid.');
    }

    return List.unmodifiable(
      (body['data'] as List).map((item) {
        if (item is! Map) {
          throw const FormatException('News item must be an object.');
        }
        return NewsItemModel.fromJson(Map<String, dynamic>.from(item));
      }),
    );
  }
}
