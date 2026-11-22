import 'package:crypto_currency/feature/wallet/data/data_source/remote/api_provider.dart';
import 'package:crypto_currency/feature/wallet/data/repository/wallet_repository_impl.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/core/utils/constants.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setup() {
  // rest api
  locator.registerSingleton<ApiProvider>(
    ApiProvider(authorization: Constants.walletAuthorization),
  );
  locator.registerSingleton<WalletRepository>(
    WalletRepositoryImpl(locator<ApiProvider>()),
  );
  // use case
  locator.registerSingleton<GetWalletUseCase>(GetWalletUseCase(locator()));

  // bloc
  locator.registerSingleton<WalletBloc>(WalletBloc(locator()));
}
