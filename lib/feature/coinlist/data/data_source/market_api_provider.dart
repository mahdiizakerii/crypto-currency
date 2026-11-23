import 'package:crypto_currency/core/utils/constants.dart';
import 'package:crypto_currency/feature/coinlist/data/models/coin_price_point_model.dart';
import 'package:crypto_currency/feature/coinlist/data/models/market_coin_model.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:dio/dio.dart';

class MarketApiProvider {
  MarketApiProvider({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<MarketCoin>> getCoins() async {
    final response = await _dio.get(
      Constants.walletBaseUrl,
      queryParameters: const {'method': 'coins', 'per_page': 50, 'page': 1},
    );
    final data = _responseData(response.data);
    if (data is! List) {
      throw const FormatException('Coin response data must be a list.');
    }

    return List.unmodifiable(
      data.map((item) {
        if (item is! Map) {
          throw const FormatException('Coin item must be an object.');
        }
        return MarketCoinModel.fromJson(Map<String, dynamic>.from(item));
      }),
    );
  }

  Future<List<CoinPricePoint>> getCoinChart(String id, int days) async {
    final response = await _dio.get(
      Constants.walletBaseUrl,
      queryParameters: {'method': 'coins_chart', 'id': id, 'days': days},
    );
    final data = _responseData(response.data);
    if (data is! Map) {
      throw const FormatException('Chart response data must be an object.');
    }

    return CoinPricePointModel.fromJson(Map<String, dynamic>.from(data));
  }

  Object? _responseData(Object? response) {
    if (response is! Map || response['success'] != true) {
      throw const FormatException('Market request was not successful.');
    }
    return response['data'];
  }
}
