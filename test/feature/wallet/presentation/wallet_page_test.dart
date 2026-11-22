import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/domain/repository/wallet_repository.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/pages/wallet_page.dart';
import 'package:crypto_currency/feature/wallet/presentation/widgets/wallet_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the empty wallet and persistent navigation tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider<WalletBloc>(
        create: (_) => WalletBloc(GetWalletUseCase(_EmptyWalletRepository())),
        child: MaterialApp(theme: AppTheme.dark, home: const WalletPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Your wallet is empty'), findsOneWidget);
    expect(find.byType(WalletAppBar), findsOneWidget);
    expect(find.text(r'$0.00'), findsOneWidget);
    expect(find.text('Chart'), findsOneWidget);
    expect(find.byIcon(Icons.show_chart_rounded), findsOneWidget);
    expect(find.text('News'), findsOneWidget);
    expect(find.text('Collectibles'), findsOneWidget);
  });
}

class _EmptyWalletRepository extends WalletRepository {
  @override
  Future<DataState<WalletEntities>> getWallet() async {
    return const DataSuccess(
      WalletEntities(
        success: true,
        data: WalletData(
          totalBalanceUsd: 0,
          walletAddress: null,
          walletType: null,
          isBiometricEnabled: false,
          assets: [],
        ),
      ),
    );
  }
}
