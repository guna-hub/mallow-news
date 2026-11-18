import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mallow_news/core/constants/api_constants.dart';
import 'package:mallow_news/core/errors/api_exception.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/domain/repositories/news_repository.dart';
import 'package:mallow_news/presentation/bloc/news_event.dart';
import 'package:mallow_news/presentation/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _newsRepository;

  NewsBloc(this._newsRepository) : super(const NewsState()) {
    on<FetchInitialNews>(_onFetchInitialNews);
    on<RefreshNews>(_onRefreshNews);
    on<LoadMoreNews>(_onLoadMoreNews);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<CategorySelected>(_onCategorySelected);
  }

  Future<void> _onFetchInitialNews(
    FetchInitialNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(
      status: NewsStatus.loading,
      errorMessage: null,
      offset: 0,
      hasReachedMax: false,
    ));

    try {
      final response = await _newsRepository.getArticles(
        limit: ApiConstants.defaultPageSize,
        offset: 0,
        search: state.searchQuery,
        newsSite: state.selectedCategory,
      );

      final validResults = _filterValidArticles(response.results);
      final hasReachedMax = response.next == null || validResults.length < ApiConstants.defaultPageSize;

      emit(state.copyWith(
        status: NewsStatus.success,
        articles: validResults,
        hasReachedMax: hasReachedMax,
        offset: validResults.length,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: NewsStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NewsStatus.failure,
        errorMessage: 'An unexpected error occurred. Please try again.',
      ));
    }
  }

  Future<void> _onRefreshNews(
    RefreshNews event,
    Emitter<NewsState> emit,
  ) async {
    try {
      final response = await _newsRepository.getArticles(
        limit: ApiConstants.defaultPageSize,
        offset: 0,
        search: state.searchQuery,
        newsSite: state.selectedCategory,
      );

      final validResults = _filterValidArticles(response.results);
      final hasReachedMax = response.next == null || validResults.length < ApiConstants.defaultPageSize;

      emit(state.copyWith(
        status: NewsStatus.success,
        articles: validResults,
        hasReachedMax: hasReachedMax,
        offset: validResults.length,
        clearLoadMoreError: true,
      ));
    } on ApiException catch (e) {
      // On refresh failure with existing articles, show error message without clearing UI
      if (state.articles.isEmpty) {
        emit(state.copyWith(
          status: NewsStatus.failure,
          errorMessage: e.message,
        ));
      }
    } catch (_) {
      if (state.articles.isEmpty) {
        emit(state.copyWith(
          status: NewsStatus.failure,
          errorMessage: 'Failed to refresh news.',
        ));
      }
    }
  }

  Future<void> _onLoadMoreNews(
    LoadMoreNews event,
    Emitter<NewsState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax || state.status != NewsStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    try {
      final response = await _newsRepository.getArticles(
        limit: ApiConstants.defaultPageSize,
        offset: state.offset,
        search: state.searchQuery,
        newsSite: state.selectedCategory,
      );

      final newArticles = _filterValidArticles(response.results);
      final hasReachedMax = response.next == null || newArticles.isEmpty;

      final updatedArticles = List<ResultsResponse>.from(state.articles)..addAll(newArticles);

      emit(state.copyWith(
        articles: updatedArticles,
        isLoadingMore: false,
        hasReachedMax: hasReachedMax,
        offset: state.offset + newArticles.length,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        loadMoreError: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        loadMoreError: 'Failed to load more news.',
      ));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<NewsState> emit,
  ) async {
    if (event.query == state.searchQuery) return;

    emit(state.copyWith(
      searchQuery: event.query,
      offset: 0,
      hasReachedMax: false,
      clearLoadMoreError: true,
    ));

    add(const FetchInitialNews());
  }

  Future<void> _onCategorySelected(
    CategorySelected event,
    Emitter<NewsState> emit,
  ) async {
    if (event.category == state.selectedCategory) return;

    emit(state.copyWith(
      selectedCategory: event.category,
      offset: 0,
      hasReachedMax: false,
      clearLoadMoreError: true,
    ));

    add(const FetchInitialNews());
  }

  List<ResultsResponse> _filterValidArticles(List<ResultsResponse?>? rawList) {
    if (rawList == null) return [];
    return rawList.whereType<ResultsResponse>().toList();
  }
}
