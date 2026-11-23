import 'package:crypto_currency/feature/news/data/models/news_item_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the news fields used by the feed page', () {
    final item = NewsItemModel.fromJson({
      'id': 13,
      'title': 'A crypto story',
      'source': 'News Desk',
      'timeAgo': '2h ago',
      'category': 'Markets',
      'summary': 'Story summary',
      'imageUrl': 'https://example.com/story.png',
      'isHot': '1',
    });

    expect(item.id, '13');
    expect(item.title, 'A crypto story');
    expect(item.category, 'Markets');
    expect(item.isHot, isTrue);
    expect(item.imageUrl, 'https://example.com/story.png');
  });

  test('rejects news without the title or summary', () {
    expect(
      () => NewsItemModel.fromJson({'title': 'Missing summary'}),
      throwsFormatException,
    );
  });
}
