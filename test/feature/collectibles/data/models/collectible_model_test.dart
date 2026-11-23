import 'package:crypto_currency/feature/collectibles/data/models/collectible_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses collectible details from the API response', () {
    final item = CollectibleModel.fromJson({
      'id': 20,
      'name': 'Doodles Genesis #9001',
      'artist': 'Burnt Toast',
      'imageUrl': 'https://example.com/nft.jpeg',
      'currentBid': '4.6500',
      'currency': 'ETH',
      'category': 'art',
      'description': 'A collectible description',
    });

    expect(item.id, '20');
    expect(item.name, 'Doodles Genesis #9001');
    expect(item.artist, 'Burnt Toast');
    expect(item.bid, '4.6500');
    expect(item.currency, 'ETH');
  });

  test('rejects collectibles without a name', () {
    expect(() => CollectibleModel.fromJson({'id': 20}), throwsFormatException);
  });
}
