import 'package:flutter_test/flutter_test.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/domain/repositories/news_repository.dart';
import 'package:mallow_news/domain/usecases/get_article_by_id_usecase.dart';
import 'package:mallow_news/domain/usecases/get_articles_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository mockRepository;
  late GetArticlesUseCase getArticlesUseCase;
  late GetArticleByIdUseCase getArticleByIdUseCase;

  setUp(() {
    mockRepository = MockNewsRepository();
    getArticlesUseCase = GetArticlesUseCase(mockRepository);
    getArticleByIdUseCase = GetArticleByIdUseCase(mockRepository);
  });

  final sampleArticle = ResultsResponse(
    42,
    'Falcon 9 Launches Starlink',
    [],
    'https://example.com/starlink',
    null,
    'SpaceX',
    'Another batch of satellites in orbit.',
    '2026-11-18T10:00:00Z',
    '2026-11-18T10:00:00Z',
    false,
    [],
    [],
  );

  final sampleResponse = ArticleResponse(
    1,
    null,
    null,
    [sampleArticle],
  );

  group('GetArticlesUseCase', () {
    test('calls repository.getArticles with correct parameters and returns ArticleResponse', () async {
      when(() => mockRepository.getArticles(
            limit: 10,
            offset: 20,
            search: 'Falcon',
            newsSite: 'SpaceX',
          )).thenAnswer((_) async => sampleResponse);

      const params = GetArticlesParams(
        limit: 10,
        offset: 20,
        search: 'Falcon',
        newsSite: 'SpaceX',
      );

      final result = await getArticlesUseCase(params);

      expect(result, equals(sampleResponse));
      expect(result.results?.first?.title, 'Falcon 9 Launches Starlink');
      verify(() => mockRepository.getArticles(
            limit: 10,
            offset: 20,
            search: 'Falcon',
            newsSite: 'SpaceX',
          )).called(1);
    });
  });

  group('GetArticleByIdUseCase', () {
    test('calls repository.getArticleById with correct ID and returns ResultsResponse', () async {
      when(() => mockRepository.getArticleById(42)).thenAnswer((_) async => sampleArticle);

      const params = GetArticleByIdParams(id: 42);
      final result = await getArticleByIdUseCase(params);

      expect(result, equals(sampleArticle));
      expect(result.id, 42);
      verify(() => mockRepository.getArticleById(42)).called(1);
    });
  });
}
