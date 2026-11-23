import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';

class CollectibleModel extends Collectible {
  const CollectibleModel({
    required super.id,
    required super.name,
    required super.artist,
    required super.bid,
    required super.currency,
    required super.category,
    required super.description,
    super.imageUrl,
  });

  factory CollectibleModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    if (name is! String || name.isEmpty) {
      throw const FormatException('Collectible name is missing.');
    }

    return CollectibleModel(
      id: json['id']?.toString() ?? '',
      name: name,
      artist: _stringValue(json['artist']) ?? 'Unknown artist',
      bid: _stringValue(json['currentBid']) ?? '—',
      currency: _stringValue(json['currency']) ?? '',
      category: _stringValue(json['category']) ?? 'Collectible',
      description: _stringValue(json['description']) ?? '',
      imageUrl: _stringValue(json['imageUrl']),
    );
  }

  static String? _stringValue(Object? value) {
    return value?.toString();
  }
}
