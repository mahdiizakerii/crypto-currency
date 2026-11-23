import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';
import 'package:crypto_currency/feature/collectibles/domain/repositories/collectibles_repository.dart';

class GetCollectiblesUseCase {
  GetCollectiblesUseCase(this.repository);

  final CollectiblesRepository repository;

  Future<List<Collectible>> call() => repository.getCollectibles();
}
