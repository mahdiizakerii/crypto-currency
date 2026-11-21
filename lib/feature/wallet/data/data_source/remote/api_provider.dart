import 'package:crypto_currency/core/utils/constants.dart';
import 'package:crypto_currency/feature/wallet/data/models/wallet_model.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  ApiProvider(String authorization, {Dio? dio})
    : _authorization = authorization,
      _dio = dio ?? Dio();

  final String _authorization;
  final Dio _dio;

  Future<WalletModel> getWalletData() async {
    final response = await _dio.get(
      Constants.walletBaseUrl,
      queryParameters: const {'method': 'wallet'},
      options: Options(headers: {'Authorization': _authorization}),
    );

    final responseData = response.data;
    if (responseData is! Map) {
      throw const FormatException('Wallet response must be a JSON object.');
    }

    return WalletModel.fromJson(Map<String, dynamic>.from(responseData));
  }
}
