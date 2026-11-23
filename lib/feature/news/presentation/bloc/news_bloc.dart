import 'package:bloc/bloc.dart';
import 'package:crypto_currency/feature/news/domain/entities/news_item.dart';
import 'package:crypto_currency/feature/news/domain/use_cases/get_news_use_case.dart';

abstract class NewsEvent {}

class NewsRequested extends NewsEvent {}

class NewsState {
  const NewsState({this.items = const [], this.isLoading = false, this.error});

  final List<NewsItem> items;
  final bool isLoading;
  final String? error;

  NewsState copyWith({
    List<NewsItem>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return NewsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(this.getNews) : super(const NewsState()) {
    on<NewsRequested>(_onRequested);
  }

  final GetNewsUseCase getNews;

  Future<void> _onRequested(
    NewsRequested event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      emit(state.copyWith(items: await getNews(), isLoading: false));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
