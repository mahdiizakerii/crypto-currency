import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/core/resources/usecase/use_case.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';

class GetWalletUseCase extends UseCase<DataState<WalletEntities>, void> {
  final WalletRepository walletRepository;
  GetWalletUseCase(this.walletRepository);
  @override
  Future<DataState<WalletEntities>> call(void params) {
    return walletRepository.getWallet();
  }
}
