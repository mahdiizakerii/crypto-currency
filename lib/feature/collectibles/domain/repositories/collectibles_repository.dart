import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';

abstract class CollectiblesRepository {
  Future<List<Collectible>> getCollectibles();
}
