import 'package:crypto_currency/feature/wallet/data/models/wallet_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses wallet response with nullable values and no assets', () {
    final wallet = WalletModel.fromJson({
      'success': true,
      'data': {
        'totalBalanceUsd': 0,
        'walletAddress': null,
        'walletType': null,
        'isBiometricEnabled': false,
        'assets': [],
      },
    });

    expect(wallet.success, isTrue);
    expect(wallet.data.totalBalanceUsd, 0);
    expect(wallet.data.walletAddress, isNull);
    expect(wallet.data.walletType, isNull);
    expect(wallet.data.isBiometricEnabled, isFalse);
    expect(wallet.data.assets, isEmpty);
    expect(wallet.toJson()['data'], {
      'totalBalanceUsd': 0,
      'walletAddress': null,
      'walletType': null,
      'isBiometricEnabled': false,
      'assets': [],
    });
  });

  test('surfaces the API error when the wallet request fails', () {
    expect(
      () => WalletModel.fromJson({
        'success': false,
        'error': 'Not authenticated',
      }),
      throwsFormatException,
    );
  });
}
