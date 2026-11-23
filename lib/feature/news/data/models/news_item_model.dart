import 'package:crypto_currency/feature/news/domain/entities/news_item.dart';

class NewsItemModel extends NewsItem {
  const NewsItemModel({
    required super.id,
    required super.title,
    required super.source,
    required super.timeAgo,
    required super.category,
    required super.summary,
    super.imageUrl,
    super.isHot,
  });

  factory NewsItemModel.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final summary = json['summary'];
    if (title is! String || summary is! String) {
      throw const FormatException('News item is missing required text.');
    }

    return NewsItemModel(
      id: json['id']?.toString() ?? '',
      title: title,
      source: _stringValue(json['source']) ?? 'Crypto news',
      timeAgo: _stringValue(json['timeAgo']) ?? '',
      category: _stringValue(json['category']) ?? 'News',
      summary: summary,
      imageUrl: _stringValue(json['imageUrl']),
      isHot: json['isHot'] == true || json['isHot']?.toString() == '1',
    );
  }

  static String? _stringValue(Object? value) {
    return value is String && value.isNotEmpty ? value : null;
  }
}
