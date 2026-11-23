import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() async {
    await locator.reset();
  });

  test('setup is idempotent and creates a new wallet bloc per scope', () async {
    await locator.reset();

    setup();
    setup();

    final firstBloc = locator<WalletBloc>();
    final secondBloc = locator<WalletBloc>();

    expect(identical(firstBloc, secondBloc), isFalse);

    await firstBloc.close();
    await secondBloc.close();
  });
}
