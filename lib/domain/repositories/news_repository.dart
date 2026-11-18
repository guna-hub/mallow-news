import 'package:mallow_news/data/models/article_model.dart';

abstract class NewsRepository {
  Future<ArticleResponse> getArticles({
    int limit = 20,
    int offset = 0,
    String? search,
    String? newsSite,
  });

  Future<ResultsResponse> getArticleById(int id);
}
