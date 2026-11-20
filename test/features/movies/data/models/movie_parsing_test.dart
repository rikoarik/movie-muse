import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_muse/core/error/exceptions.dart';
import 'package:movie_muse/core/network/api_client.dart';
import 'package:movie_muse/features/movies/data/datasources/omdb_remote_datasource.dart';
import 'package:movie_muse/features/movies/data/models/movie_detail_model.dart';
import 'package:movie_muse/features/movies/data/models/movie_search_result_model.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('MovieSearchResultModel.fromOmdbJson', () {
    test('parses valid entries, deduplicates, and normalizes N/A posters', () {
      final model = MovieSearchResultModel.fromOmdbJson(const {
        'Search': [
          {
            'Title': 'Batman Begins',
            'Year': '2005',
            'imdbID': 'tt0372784',
            'Type': 'movie',
            'Poster': 'https://example.com/batman-begins.jpg',
          },
          {
            'Title': 'Batman Begins Duplicate',
            'Year': '2005',
            'imdbID': 'tt0372784',
            'Type': 'movie',
            'Poster': 'N/A',
          },
          {
            'Title': 'Mask of the Phantasm',
            'Year': '1993',
            'imdbID': 'tt0106364',
            'Type': 'movie',
            'Poster': 'N/A',
          },
          {
            'Title': 'Invalid No ID',
            'Year': '2000',
            'imdbID': '',
            'Type': 'movie',
            'Poster': 'not-a-url',
          },
        ],
        'totalResults': '42',
        'Response': 'True',
      });

      expect(model.totalResults, 42);
      expect(model.movies, hasLength(2));
      expect(model.movies[0].poster, 'https://example.com/batman-begins.jpg');
      expect(model.movies[1].poster, isNull);
      expect(model.movies[1].monogram, 'MO');
    });

    test('handles absent Search and invalid totalResults defensively', () {
      final model = MovieSearchResultModel.fromOmdbJson(const {
        'totalResults': 'invalid-number',
      });

      expect(model.movies, isEmpty);
      expect(model.totalResults, 0);
    });
  });

  group('MovieDetailModel.fromOmdbJson', () {
    test('normalizes N/A and empty fields to null', () {
      final detail = MovieDetailModel.fromOmdbJson(const {
        'imdbID': 'tt0372784',
        'Title': 'Batman Begins',
        'Year': '2005',
        'Poster': 'N/A',
        'Plot': 'N/A',
        'Genre': 'Action, Crime',
        'Director': 'Christopher Nolan',
        'Actors': '  ',
        'Runtime': '140 min',
        'imdbRating': 'N/A',
        'Released': 'N/A',
      });

      expect(detail.poster, isNull);
      expect(detail.plot, isNull);
      expect(detail.actors, isNull);
      expect(detail.castList, isEmpty);
      expect(detail.imdbRating, isNull);
      expect(detail.released, isNull);
      expect(detail.genreList, ['Action', 'Crime']);
      expect(detail.director, 'Christopher Nolan');
      expect(detail.runtime, '140 min');
    });

    test('throws ParseException when mandatory imdbID is missing', () {
      expect(
        () => MovieDetailModel.fromOmdbJson(const {
          'imdbID': 'N/A',
          'Title': 'Batman Begins',
        }),
        throwsA(isA<ParseException>()),
      );
    });
  });

  group('OmdbRemoteDataSourceImpl', () {
    late _MockApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    test('throws ApiConfigurationException when API key is empty', () async {
      final dataSource = OmdbRemoteDataSourceImpl(apiClient, apiKey: '  ');

      await expectLater(
        () => dataSource.searchMovies(query: 'batman'),
        throwsA(isA<ApiConfigurationException>()),
      );
      verifyZeroInteractions(apiClient);
    });

    test('maps Movie not found! response to empty search result', () async {
      when(
        () => apiClient.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(),
          data: const {'Response': 'False', 'Error': 'Movie not found!'},
        ),
      );

      final dataSource = OmdbRemoteDataSourceImpl(
        apiClient,
        apiKey: 'demo-key',
      );
      final result = await dataSource.searchMovies(query: 'xyznonexistent');

      expect(result.movies, isEmpty);
      expect(result.totalResults, 0);
    });

    test('maps Invalid API key! response to InvalidApiKeyException', () async {
      when(
        () => apiClient.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(),
          data: const {'Response': 'False', 'Error': 'Invalid API key!'},
        ),
      );

      final dataSource = OmdbRemoteDataSourceImpl(apiClient, apiKey: 'bad-key');

      await expectLater(
        () => dataSource.getMovieDetail('tt0372784'),
        throwsA(isA<InvalidApiKeyException>()),
      );
    });
  });
}
