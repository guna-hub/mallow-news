import 'package:dio/dio.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/articles/')
  Future<ArticleResponse> getArticleList({
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
    @Query('search') String? searchText,
    @Query('news_site') String? newsSite,
  });

  @GET('/articles/{id}/')
  Future<ResultsResponse> getArticleById({
    @Path('id') required int id,
  });
}
