import 'package:injectable/injectable.dart';
import 'package:mallow_news/core/usecase/usecase.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/domain/repositories/news_repository.dart';
import 'package:mallow_news/domain/usecases/parameters/get_article_by_id_params.dart';

export 'package:mallow_news/domain/usecases/parameters/get_article_by_id_params.dart';

/// Use case responsible for retrieving a single article by its unique ID.
@lazySingleton
class GetArticleByIdUseCase implements UseCase<ResultsResponse, GetArticleByIdParams> {
  final NewsRepository _repository;

  GetArticleByIdUseCase(this._repository);

  @override
  Future<ResultsResponse> call(GetArticleByIdParams params) async {
    return await _repository.getArticleById(params.id);
  }
}
