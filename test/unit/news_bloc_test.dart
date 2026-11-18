import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mallow_news/core/errors/api_exception.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/domain/repositories/news_repository.dart';
import 'package:mallow_news/presentation/bloc/news_bloc.dart';
import 'package:mallow_news/presentation/bloc/news_event.dart';
import 'package:mallow_news/presentation/bloc/news_state.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository mockRepository;

  final sampleArticle = ResultsResponse(
    1,
    'Artemis II Mission Update',
    [ResultsAuthorsResponse('Jane Doe', null)],
    'https://example.com/artemis',
    'https://example.com/artemis.jpg',
    'NASA Spaceflight',
    'Artemis crew is training.',
    '2026-11-17T12:00:00Z',
    '2026-11-17T12:00:00Z',
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

  setUp(() {
    mockRepository = MockNewsRepository();
  });

  group('NewsBloc Tests', () {
    test('initial state has NewsStatus.initial', () {
      final bloc = NewsBloc(mockRepository);
      expect(bloc.state.status, NewsStatus.initial);
      expect(bloc.state.articles, isEmpty);
    });

    blocTest<NewsBloc, NewsState>(
      'emits [loading, success] when FetchInitialNews is added and succeeds',
      build: () {
        when(() => mockRepository.getArticles(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
              newsSite: any(named: 'newsSite'),
            )).thenAnswer((_) async => sampleResponse);
        return NewsBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const FetchInitialNews()),
      expect: () => [
        const NewsState(status: NewsStatus.loading),
        NewsState(
          status: NewsStatus.success,
          articles: [sampleArticle],
          hasReachedMax: true,
          offset: 1,
        ),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'emits [loading, failure] when FetchInitialNews fails with ApiException',
      build: () {
        when(() => mockRepository.getArticles(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
              newsSite: any(named: 'newsSite'),
            )).thenThrow(const ApiException(
          message: 'No internet connection',
          type: ApiErrorType.noInternet,
        ));
        return NewsBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const FetchInitialNews()),
      expect: () => [
        const NewsState(status: NewsStatus.loading),
        const NewsState(
          status: NewsStatus.failure,
          errorMessage: 'No internet connection',
        ),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'emits updated search query and triggers initial fetch',
      build: () {
        when(() => mockRepository.getArticles(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              search: any(named: 'search'),
              newsSite: any(named: 'newsSite'),
            )).thenAnswer((_) async => sampleResponse);
        return NewsBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('Moon')),
      expect: () => [
        const NewsState(searchQuery: 'Moon'),
        const NewsState(searchQuery: 'Moon', status: NewsStatus.loading),
        NewsState(
          searchQuery: 'Moon',
          status: NewsStatus.success,
          articles: [sampleArticle],
          hasReachedMax: true,
          offset: 1,
        ),
      ],
    );
  });
}
