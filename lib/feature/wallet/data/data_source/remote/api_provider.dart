import 'package:tonkeeper/core/utils/constants.dart';
import 'package:tonkeeper/feature/wallet/data/models/wallet_model.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  ApiProvider({Dio? dio, String? authorization})
    : _authorization = authorization?.trim(),
      _dio = dio ?? Dio();

  final String? _authorization;
  final Dio _dio;

  Future<WalletModel> getWalletData() async {
    final response = await _dio.get(
      Constants.walletBaseUrl,
      queryParameters: const {'method': 'wallet'},
      options: _authorization == null
          ? null
          : Options(headers: {'Authorization': _authorization}),
    );

    final responseData = response.data;
    if (responseData is! Map) {
      throw const FormatException('Wallet response must be a JSON object.');
    }

    return WalletModel.fromJson(Map<String, dynamic>.from(responseData));
  }
}
