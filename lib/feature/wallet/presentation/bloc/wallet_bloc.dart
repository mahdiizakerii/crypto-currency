import 'package:crypto_currency/core/resources/data_state.dart';
import 'package:crypto_currency/feature/wallet/domain/use_cases/get_wallet_use_case.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletUseCase getWalletUseCase;
  WalletBloc(this.getWalletUseCase)
    : super(WalletState(walletStatus: WalletLoading())) {
    on<FetchWalletData>(onFetchWalletData);
  }
  Future<void> onFetchWalletData(
    FetchWalletData event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(WalletLoading()));
    DataState dataState = await getWalletUseCase(null);
    if (dataState is DataSuccess) {
      emit(state.copyWith(WalletLoaded(dataState.data)));
    }
    if (dataState is DataFailed) {
      emit(
        WalletState(
          walletStatus: WalletError(dataState.errorMessage ?? "Error"),
        ),
      );
    }
  }
}
