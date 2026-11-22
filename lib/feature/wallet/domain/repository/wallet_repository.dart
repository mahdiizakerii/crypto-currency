import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';

abstract class WalletRepository {
  Future<DataState<WalletEntities>> getWallet();
}
