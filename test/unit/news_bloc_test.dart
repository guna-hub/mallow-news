import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mallow_news/core/di/injection_container.dart';
import 'package:mallow_news/core/errors/api_exception.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/domain/usecases/get_articles_usecase.dart';
import 'package:mallow_news/presentation/bloc/news_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetArticlesUseCase extends Mock implements GetArticlesUseCase {}

void main() {
  late MockGetArticlesUseCase mockGetArticlesUseCase;

  setUpAll(() {
    registerFallbackValue(const GetArticlesParams());
  });

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

  setUp(() async {
    await getIt.reset();
    mockGetArticlesUseCase = MockGetArticlesUseCase();
    getIt.registerSingleton<GetArticlesUseCase>(mockGetArticlesUseCase);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('NewsBloc Tests', () {
    test('initial state has NewsStatus.initial', () {
      final bloc = NewsBloc(getArticlesUseCase: mockGetArticlesUseCase);
      expect(bloc.state.status, NewsStatus.initial);
      expect(bloc.state.articles, isEmpty);
    });

    blocTest<NewsBloc, NewsState>(
      'emits [loading, success] when FetchInitialNews is added and succeeds',
      build: () {
        when(() => mockGetArticlesUseCase(any())).thenAnswer((_) async => sampleResponse);
        return NewsBloc(getArticlesUseCase: mockGetArticlesUseCase);
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
        when(() => mockGetArticlesUseCase(any())).thenThrow(const ApiException(
          message: 'No internet connection',
          type: ApiErrorType.noInternet,
        ));
        return NewsBloc(getArticlesUseCase: mockGetArticlesUseCase);
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
        when(() => mockGetArticlesUseCase(any())).thenAnswer((_) async => sampleResponse);
        return NewsBloc(getArticlesUseCase: mockGetArticlesUseCase);
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
