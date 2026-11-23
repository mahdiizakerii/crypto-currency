import 'package:crypto_currency/feature/coinlist/data/models/coin_price_point_model.dart';
import 'package:crypto_currency/feature/coinlist/data/models/market_coin_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses market coin values returned by the API', () {
    final coin = MarketCoinModel.fromJson({
      'id': '1',
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'image': 'https://example.com/btc.png',
      'current_price': 64000.5,
      'price_change_percentage_24h': -1.25,
    });

    expect(coin.id, '1');
    expect(coin.symbol, 'BTC');
    expect(coin.price, 64000.5);
    expect(coin.change24h, -1.25);
    expect(coin.imageUrl, 'https://example.com/btc.png');
  });

  test('parses matching chart timestamps and close prices', () {
    final points = CoinPricePointModel.fromJson({
      't': [1000, 2000],
      'c': [12.5, 15],
    });

    expect(points, hasLength(2));
    expect(points.first.price, 12.5);
    expect(points.last.price, 15);
    expect(points.first.time.millisecondsSinceEpoch, 1000000);
  });

  test('reports chart responses without usable points', () {
    expect(
      () => CoinPricePointModel.fromJson({'t': [], 'c': []}),
      throwsFormatException,
    );
  });
}
