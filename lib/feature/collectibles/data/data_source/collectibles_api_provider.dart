import 'package:crypto_currency/core/utils/constants.dart';
import 'package:crypto_currency/feature/collectibles/data/models/collectible_model.dart';
import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';
import 'package:dio/dio.dart';

class CollectiblesApiProvider {
  CollectiblesApiProvider({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<Collectible>> getCollectibles() async {
    final response = await _dio.get(
      Constants.walletBaseUrl,
      queryParameters: const {'method': 'collectibles', 'limit': 30},
    );
    final body = response.data;
    if (body is! Map || body['success'] != true || body['data'] is! List) {
      throw const FormatException('Collectibles response data is invalid.');
    }

    return List.unmodifiable(
      (body['data'] as List).map((item) {
        if (item is! Map) {
          throw const FormatException('Collectible item must be an object.');
        }
        return CollectibleModel.fromJson(Map<String, dynamic>.from(item));
      }),
    );
  }
}
