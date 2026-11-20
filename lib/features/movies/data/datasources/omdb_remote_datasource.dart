import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/core/error/exceptions.dart';
import 'package:movie_muse/core/network/api_client.dart';
import 'package:movie_muse/features/movies/data/models/movie_detail_model.dart';
import 'package:movie_muse/features/movies/data/models/movie_search_result_model.dart';

abstract interface class OmdbRemoteDataSource {
  Future<MovieSearchResultModel> searchMovies({
    required String query,
    int page = 1,
  });

  Future<MovieDetailModel> getMovieDetail(String imdbId);
}

class OmdbRemoteDataSourceImpl implements OmdbRemoteDataSource {
  const OmdbRemoteDataSourceImpl(this._apiClient, {this.apiKey});

  final ApiClient _apiClient;
  final String? apiKey;

  String _requireApiKey() {
    final key = (apiKey ?? EnvConfig.omdbApiKey).trim();
    if (key.isEmpty) {
      throw const ApiConfigurationException();
    }
    return key;
  }

  @override
  Future<MovieSearchResultModel> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final apiKey = _requireApiKey();
    final response = await _apiClient.get<Map<String, dynamic>>(
      '',
      queryParameters: {
        'apikey': apiKey,
        's': query.trim(),
        'type': 'movie',
        'page': page,
      },
    );

    final body = response.data;
    if (body == null) {
      throw const ParseException('Empty response from OMDb.');
    }

    final isTrue = _isResponseTrue(body);
    if (!isTrue) {
      final errorMessage = _extractErrorMessage(body);
      final lower = errorMessage.toLowerCase();
      if (lower.contains('invalid api key') ||
          lower.contains('no api key provided')) {
        throw const InvalidApiKeyException();
      }
      if (lower.contains('not found') || lower.contains('too many results')) {
        return const MovieSearchResultModel(movies: [], totalResults: 0);
      }
      throw ServerException(errorMessage);
    }

    return MovieSearchResultModel.fromOmdbJson(body);
  }

  @override
  Future<MovieDetailModel> getMovieDetail(String imdbId) async {
    final apiKey = _requireApiKey();
    final response = await _apiClient.get<Map<String, dynamic>>(
      '',
      queryParameters: {'apikey': apiKey, 'i': imdbId.trim(), 'plot': 'full'},
    );

    final body = response.data;
    if (body == null) {
      throw const ParseException('Empty response from OMDb.');
    }

    if (!_isResponseTrue(body)) {
      final errorMessage = _extractErrorMessage(body);
      final lower = errorMessage.toLowerCase();
      if (lower.contains('invalid api key') ||
          lower.contains('no api key provided')) {
        throw const InvalidApiKeyException();
      }
      throw ServerException(errorMessage);
    }

    return MovieDetailModel.fromOmdbJson(body);
  }

  bool _isResponseTrue(Map<String, dynamic> body) {
    final raw = body['Response'];
    return raw is String && raw.trim().toLowerCase() == 'true';
  }

  String _extractErrorMessage(Map<String, dynamic> body) {
    final raw = body['Error'];
    if (raw is String && raw.trim().isNotEmpty) {
      return raw.trim();
    }
    return 'Unable to fetch data from OMDb.';
  }
}
