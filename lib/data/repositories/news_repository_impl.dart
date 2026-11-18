import 'package:dio/dio.dart';
import 'package:mallow_news/core/errors/api_exception.dart';
import 'package:mallow_news/core/network/api_client.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final ApiClient _apiClient;

  NewsRepositoryImpl(this._apiClient);

  @override
  Future<ArticleResponse> getArticles({
    int limit = 20,
    int offset = 0,
    String? search,
    String? newsSite,
  }) async {
    try {
      final sanitizedSearch = search != null && search.trim().isNotEmpty
          ? search.trim()
          : null;
      final sanitizedSite = newsSite != null && newsSite.trim().isNotEmpty && newsSite != 'All'
          ? newsSite.trim()
          : null;

      final response = await _apiClient.getArticleList(
        limit: limit,
        offset: offset,
        searchText: sanitizedSearch,
        newsSite: sanitizedSite,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        type: ApiErrorType.unknown,
      );
    }
  }

  @override
  Future<ResultsResponse> getArticleById(int id) async {
    try {
      final response = await _apiClient.getArticleById(id: id);
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        type: ApiErrorType.unknown,
      );
    }
  }
}
