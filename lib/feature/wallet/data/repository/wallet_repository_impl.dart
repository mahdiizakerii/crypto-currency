import 'dart:math';

import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/feature/wallet/data/data_source/remote/api_provider.dart';
import 'package:crypto_currency/feature/wallet/data/models/wallet_model.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:dio/dio.dart';

class WalletRepositoryImpl extends WalletRepository {
  ApiProvider apiProvider;
  WalletRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<WalletEntities>> getWallet() async {
    try {
      Response response = await apiProvider.getWalletData() as Response;
      if (response.statusCode == 200) {
        WalletEntities walletEntities = WalletModel.fromJson(response.data);
        return DataSuccess(walletEntities);
      } else {
        return DataFailed("Failed to fetch wallet data: $e");
      }
    } catch (e) {
      return DataFailed("Failed to fetch wallet data: $e");
    }
  }
}
