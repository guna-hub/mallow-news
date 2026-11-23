import 'package:injectable/injectable.dart';
import 'package:mallow_news/core/usecase/usecase.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/domain/repositories/news_repository.dart';
import 'package:mallow_news/domain/usecases/parameters/get_articles_params.dart';

export 'package:mallow_news/domain/usecases/parameters/get_articles_params.dart';

/// Use case responsible for retrieving paginated articles, optional search query, and category filter.
@lazySingleton
class GetArticlesUseCase implements UseCase<ArticleResponse, GetArticlesParams> {
  final NewsRepository _repository;

  GetArticlesUseCase(this._repository);

  @override
  Future<ArticleResponse> call(GetArticlesParams params) async {
    return await _repository.getArticles(
      limit: params.limit,
      offset: params.offset,
      search: params.search,
      newsSite: params.newsSite,
    );
  }
}
