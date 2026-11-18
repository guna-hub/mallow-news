import 'package:equatable/equatable.dart';
import 'package:mallow_news/data/models/article_model.dart';

enum NewsStatus { initial, loading, success, failure }

class NewsState extends Equatable {
  final NewsStatus status;
  final List<ResultsResponse> articles;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? loadMoreError;
  final String? errorMessage;
  final String searchQuery;
  final String selectedCategory;
  final int offset;

  const NewsState({
    this.status = NewsStatus.initial,
    this.articles = const [],
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.offset = 0,
  });

  NewsState copyWith({
    NewsStatus? status,
    List<ResultsResponse>? articles,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? loadMoreError,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategory,
    int? offset,
    bool clearLoadMoreError = false,
  }) {
    return NewsState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [
        status,
        articles,
        hasReachedMax,
        isLoadingMore,
        loadMoreError,
        errorMessage,
        searchQuery,
        selectedCategory,
        offset,
      ];
}
