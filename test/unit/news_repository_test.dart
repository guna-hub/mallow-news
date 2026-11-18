import 'package:flutter_test/flutter_test.dart';
import 'package:mallow_news/core/network/api_client.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/data/repositories/news_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late NewsRepositoryImpl repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = NewsRepositoryImpl(mockApiClient);
  });

  group('NewsRepository Tests', () {
    test('getArticles returns ArticleResponse successfully', () async {
      final mockResponse = ArticleResponse(
        1,
        null,
        null,
        [
          ResultsResponse(
            1,
            'SpaceX Starship Launch',
            [],
            'https://example.com/starship',
            'https://example.com/image.jpg',
            'SpaceNews',
            'Test summary for Starship',
            '2026-11-17T10:00:00Z',
            '2026-11-17T10:00:00Z',
            false,
            [],
            [],
          ),
        ],
      );

      when(() => mockApiClient.getArticleList(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            searchText: any(named: 'searchText'),
            newsSite: any(named: 'newsSite'),
          )).thenAnswer((_) async => mockResponse);

      final result = await repository.getArticles(limit: 20, offset: 0);

      expect(result.results?.length, 1);
      expect(result.results?.first?.title, 'SpaceX Starship Launch');
      expect(result.results?.first?.newsSite, 'SpaceNews');
      verify(() => mockApiClient.getArticleList(limit: 20, offset: 0)).called(1);
    });

    test('getArticleById returns ResultsResponse', () async {
      final mockArticle = ResultsResponse(
        42,
        'Deep Space Exploration',
        [],
        'https://example.com/deep-space',
        'https://example.com/img.jpg',
        'NASA',
        'Summary',
        '2026-11-17T10:00:00Z',
        '2026-11-17T10:00:00Z',
        false,
        [],
        [],
      );

      when(() => mockApiClient.getArticleById(id: 42))
          .thenAnswer((_) async => mockArticle);

      final result = await repository.getArticleById(42);

      expect(result.id, 42);
      expect(result.title, 'Deep Space Exploration');
      verify(() => mockApiClient.getArticleById(id: 42)).called(1);
    });
  });
}
