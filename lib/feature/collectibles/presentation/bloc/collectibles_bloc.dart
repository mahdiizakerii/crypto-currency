import 'package:bloc/bloc.dart';
import 'package:crypto_currency/feature/collectibles/domain/entities/collectible.dart';
import 'package:crypto_currency/feature/collectibles/domain/use_cases/get_collectibles_use_case.dart';

abstract class CollectiblesEvent {}

class CollectiblesRequested extends CollectiblesEvent {}

class CollectiblesState {
  const CollectiblesState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Collectible> items;
  final bool isLoading;
  final String? error;

  CollectiblesState copyWith({
    List<Collectible>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CollectiblesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class CollectiblesBloc extends Bloc<CollectiblesEvent, CollectiblesState> {
  CollectiblesBloc(this.getCollectibles) : super(const CollectiblesState()) {
    on<CollectiblesRequested>(_onRequested);
  }

  final GetCollectiblesUseCase getCollectibles;

  Future<void> _onRequested(
    CollectiblesRequested event,
    Emitter<CollectiblesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      emit(state.copyWith(items: await getCollectibles(), isLoading: false));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
