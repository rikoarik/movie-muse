import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_muse/core/error/failures.dart';
import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_search_result.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/usecases/search_movies_usecase.dart';
import 'package:movie_muse/features/search/presentation/viewmodels/search_viewmodel.dart';

class _MockSearchMoviesUseCase extends Mock implements SearchMoviesUseCase {}

void main() {
  late _MockSearchMoviesUseCase searchUseCase;
  late SearchViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(const SearchMoviesParams(query: 'fallback'));
  });

  setUp(() {
    searchUseCase = _MockSearchMoviesUseCase();
    viewModel = SearchViewModel(
      searchMoviesUseCase: searchUseCase,
      debounceDuration: const Duration(milliseconds: 20),
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  test(
    'stays idle and skips repository for queries under 2 characters',
    () async {
      viewModel.onQueryChanged('b');
      await Future<void>.delayed(const Duration(milliseconds: 40));

      expect(viewModel.status, SearchStatus.idle);
      expect(viewModel.results, isEmpty);
      verifyNever(() => searchUseCase(any()));
    },
  );

  test('discards stale out-of-order response so latest query wins', () async {
    final firstCompleter = Completer<Result<MovieSearchResult>>();
    final secondCompleter = Completer<Result<MovieSearchResult>>();

    when(() => searchUseCase(const SearchMoviesParams(query: 'bat')))
        .thenAnswer((_) => firstCompleter.future);
    when(() => searchUseCase(const SearchMoviesParams(query: 'batman')))
        .thenAnswer((_) => secondCompleter.future);

    unawaited(viewModel.submitSearch('bat'));
    await Future<void>.delayed(Duration.zero);
    unawaited(viewModel.submitSearch('batman'));

    const batmanMovie = MovieSummary(
      imdbId: 'tt0372784',
      title: 'Batman Begins',
      year: '2005',
      type: 'movie',
    );
    const staleMovie = MovieSummary(
      imdbId: 'tt9999999',
      title: 'Bat Out of Hell',
      year: '1999',
      type: 'movie',
    );

    // Latest finishes first, then older stale response resolves afterward.
    secondCompleter.complete(
      const Success(MovieSearchResult(movies: [batmanMovie], totalResults: 1)),
    );
    await Future<void>.delayed(Duration.zero);

    firstCompleter.complete(
      const Success(MovieSearchResult(movies: [staleMovie], totalResults: 1)),
    );
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.status, SearchStatus.results);
    expect(viewModel.activeSearchedQuery, 'batman');
    expect(viewModel.results, [batmanMovie]);
  });

  test(
    'triggers live debounced search and supports empty, error, missing key',
    () async {
      const sampleMovie = MovieSummary(
        imdbId: 'tt0468569',
        title: 'The Dark Knight',
        year: '2008',
        type: 'movie',
      );

      when(() => searchUseCase(const SearchMoviesParams(query: 'knight')))
          .thenAnswer(
            (_) async => const Success(
              MovieSearchResult(movies: [sampleMovie], totalResults: 12),
            ),
          );

      viewModel.onQueryChanged('knight');
      await Future<void>.delayed(const Duration(milliseconds: 45));

      expect(viewModel.status, SearchStatus.results);
      expect(viewModel.totalResults, 12);
      expect(viewModel.results, [sampleMovie]);

      when(() => searchUseCase(const SearchMoviesParams(query: 'none')))
          .thenAnswer(
            (_) async =>
                const Success(MovieSearchResult(movies: [], totalResults: 0)),
          );
      await viewModel.submitSearch('none');
      expect(viewModel.status, SearchStatus.empty);

      when(() => searchUseCase(const SearchMoviesParams(query: 'offline')))
          .thenAnswer((_) async => const ErrorResult(NetworkFailure()));
      await viewModel.submitSearch('offline');
      expect(viewModel.status, SearchStatus.error);
      expect(viewModel.query, 'offline');

      when(
        () => searchUseCase(const SearchMoviesParams(query: 'nokey')),
      ).thenAnswer((_) async => const ErrorResult(ApiConfigurationFailure()));
      await viewModel.submitSearch('nokey');
      expect(viewModel.status, SearchStatus.missingApiKey);
    },
  );

  test('loadMore appends page 2 and deduplicates by imdbId', () async {
    const page1Movie = MovieSummary(
      imdbId: 'tt0372784',
      title: 'Batman Begins',
      year: '2005',
      type: 'movie',
    );
    const page2Movie = MovieSummary(
      imdbId: 'tt0468569',
      title: 'The Dark Knight',
      year: '2008',
      type: 'movie',
    );

    when(() => searchUseCase(const SearchMoviesParams(query: 'batman')))
        .thenAnswer(
          (_) async => const Success(
            MovieSearchResult(movies: [page1Movie], totalResults: 2),
          ),
        );
    when(
      () => searchUseCase(const SearchMoviesParams(query: 'batman', page: 2)),
    ).thenAnswer(
      (_) async => const Success(
        MovieSearchResult(movies: [page1Movie, page2Movie], totalResults: 2),
      ),
    );

    await viewModel.submitSearch('batman');
    await viewModel.loadMore();

    expect(viewModel.results, [page1Movie, page2Movie]);
  });
}
