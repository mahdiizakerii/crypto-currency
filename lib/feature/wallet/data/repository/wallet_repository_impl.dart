import 'package:tonkeeper/core/resources/data_state.dart';
import 'package:tonkeeper/feature/wallet/data/data_source/remote/api_provider.dart';
import 'package:tonkeeper/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:tonkeeper/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:dio/dio.dart';

class WalletRepositoryImpl extends WalletRepository {
  final ApiProvider apiProvider;
  WalletRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<WalletEntities>> getWallet() async {
    try {
      final wallet = await apiProvider.getWalletData();
      return DataSuccess(wallet);
    } on DioException catch (error) {
      final responseData = error.response?.data;
      if (responseData is Map && responseData['error'] is String) {
        return DataFailed(responseData['error'] as String);
      }
      return DataFailed(error.message ?? 'Failed to fetch wallet data.');
    } catch (error) {
      return DataFailed('Failed to fetch wallet data: $error');
    }
  }
}
