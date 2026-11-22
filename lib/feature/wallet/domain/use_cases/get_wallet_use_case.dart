import 'package:tonkeeper/core/resources/data_state.dart';
import 'package:tonkeeper/core/resources/usecase/use_case.dart';
import 'package:tonkeeper/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:tonkeeper/feature/wallet/domain/repository/wallet_repository.dart';

class GetWalletUseCase extends UseCase<DataState<WalletEntities>, void> {
  final WalletRepository walletRepository;
  GetWalletUseCase(this.walletRepository);
  @override
  Future<DataState<WalletEntities>> call(void params) {
    return walletRepository.getWallet();
  }
}
