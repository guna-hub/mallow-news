import 'package:equatable/equatable.dart';
import 'package:mallow_news/core/constants/api_constants.dart';

/// Parameter class for fetching articles with pagination, search, and category filter.
class GetArticlesParams extends Equatable {
  final int limit;
  final int offset;
  final String? search;
  final String? newsSite;

  const GetArticlesParams({
    this.limit = ApiConstants.defaultPageSize,
    this.offset = 0,
    this.search,
    this.newsSite,
  });

  GetArticlesParams copyWith({
    int? limit,
    int? offset,
    String? search,
    String? newsSite,
  }) {
    return GetArticlesParams(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      search: search ?? this.search,
      newsSite: newsSite ?? this.newsSite,
    );
  }

  @override
  List<Object?> get props => [limit, offset, search, newsSite];
}
