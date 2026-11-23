import 'package:crypto_currency/feature/login/bloc/login_bloc.dart';
import 'package:crypto_currency/feature/login/data/data%20source/biometric_local_datasource.dart';
import 'package:crypto_currency/feature/login/data/data%20source/repository/biometric_repository_impl.dart';
import 'package:crypto_currency/feature/login/domain/repository/biometric_repository.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/authenticate_biometric.dart';
import 'package:crypto_currency/feature/login/domain/repository/use_case/check_biometric_availability.dart';
import 'package:crypto_currency/feature/coinlist/data/data_source/market_api_provider.dart';
import 'package:crypto_currency/feature/coinlist/data/repositories/market_repository_impl.dart';
import 'package:crypto_currency/feature/coinlist/domain/repositories/market_repository.dart';
import 'package:crypto_currency/feature/coinlist/domain/use_cases/get_coin_chart_use_case.dart';
import 'package:crypto_currency/feature/coinlist/domain/use_cases/get_market_coins_use_case.dart';
import 'package:crypto_currency/feature/coinlist/presentation/bloc/market_bloc.dart';
import 'package:crypto_currency/feature/news/data/data_source/news_api_provider.dart';
import 'package:crypto_currency/feature/news/data/repositories/news_repository_impl.dart';
import 'package:crypto_currency/feature/news/domain/repositories/news_repository.dart';
import 'package:crypto_currency/feature/news/domain/use_cases/get_news_use_case.dart';
import 'package:crypto_currency/feature/news/presentation/bloc/news_bloc.dart';
import 'package:crypto_currency/feature/collectibles/data/data_source/collectibles_api_provider.dart';
import 'package:crypto_currency/feature/collectibles/data/repositories/collectibles_repository_impl.dart';
import 'package:crypto_currency/feature/collectibles/domain/repositories/collectibles_repository.dart';
import 'package:crypto_currency/feature/collectibles/domain/use_cases/get_collectibles_use_case.dart';
import 'package:crypto_currency/feature/collectibles/presentation/bloc/collectibles_bloc.dart';
import 'package:crypto_currency/feature/wallet/data/data_source/remote/api_provider.dart';
import 'package:crypto_currency/feature/wallet/data/repository/wallet_repository_impl.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/core/utils/constants.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<CollectiblesApiProvider>(
    () => CollectiblesApiProvider(),
  );
  locator.registerLazySingleton<CollectiblesRepository>(
    () => CollectiblesRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<GetCollectiblesUseCase>(
    () => GetCollectiblesUseCase(locator()),
  );
  locator.registerFactory<CollectiblesBloc>(() => CollectiblesBloc(locator()));

  locator.registerLazySingleton<NewsApiProvider>(() => NewsApiProvider());
  locator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<GetNewsUseCase>(
    () => GetNewsUseCase(locator()),
  );
  locator.registerFactory<NewsBloc>(() => NewsBloc(locator()));

  locator.registerLazySingleton<MarketApiProvider>(() => MarketApiProvider());
  locator.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<GetMarketCoinsUseCase>(
    () => GetMarketCoinsUseCase(locator()),
  );
  locator.registerLazySingleton<GetCoinChartUseCase>(
    () => GetCoinChartUseCase(locator()),
  );
  locator.registerFactory<MarketBloc>(
    () => MarketBloc(getMarketCoins: locator(), getCoinChart: locator()),
  );

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
