import 'package:crypto_currency/feature/collectibles/data/data_source/collectibles_api_provider.dart';
import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';
import 'package:crypto_currency/feature/collectibles/domain/repositories/collectibles_repository.dart';

class CollectiblesRepositoryImpl extends CollectiblesRepository {
  CollectiblesRepositoryImpl(this.apiProvider);

  final CollectiblesApiProvider apiProvider;

  @override
  Future<List<Collectible>> getCollectibles() {
    return apiProvider.getCollectibles();
  }
}
