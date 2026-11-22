import 'package:tonkeeper/core/resources/data_state.dart';
import 'package:tonkeeper/feature/wallet/domain/entites/wallet_entities.dart';

abstract class WalletRepository {
  Future<DataState<WalletEntities>> getWallet();
}
