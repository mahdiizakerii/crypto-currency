import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/data/data%20source/biometric_local_datasource.dart';
import 'package:crypto_currency/feature/login/data/data%20source/repository/biometric_repository_impl.dart';
import 'package:crypto_currency/feature/login/domain/repository/biometric_repository.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/authenticate_biometric.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/check_biometric_availability.dart';
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
    ApiProvider(
      authorization: Constants.walletAuthorization.isEmpty
          ? null
          : Constants.walletAuthorization,
    ),
  );
  locator.registerSingleton<WalletRepository>(
    WalletRepositoryImpl(locator<ApiProvider>()),
  );
  // use case
  locator.registerSingleton<GetWalletUseCase>(GetWalletUseCase(locator()));

  // bloc
  locator.registerSingleton<WalletBloc>(WalletBloc(locator()));
  // biometric datasource
  locator.registerLazySingleton<BiometricLocalDataSource>(
    () => BiometricLocalDataSourceImpl(),
  );

  // biometric repository
  locator.registerLazySingleton<BiometricRepository>(
    () => BiometricRepositoryImpl(localDataSource: locator()),
  );

  // biometric use cases
  locator.registerLazySingleton<CheckBiometricAvailability>(
    () => CheckBiometricAvailability(locator()),
  );

  locator.registerLazySingleton<AuthenticateBiometric>(
    () => AuthenticateBiometric(locator()),
  );

  // login bloc
  locator.registerFactory<LoginBloc>(
    () => LoginBloc(
      checkBiometricAvailability: locator(),
      authenticateBiometric: locator(),
    ),
  );
}
