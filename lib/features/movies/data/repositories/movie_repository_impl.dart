import 'package:movie_muse/core/error/exceptions.dart';
import 'package:movie_muse/core/error/failures.dart';
import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/features/movies/data/datasources/omdb_remote_datasource.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_search_result.dart';
import 'package:movie_muse/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this._remoteDataSource);

  final OmdbRemoteDataSource _remoteDataSource;

  @override
  Future<Result<MovieSearchResult>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    return _mapExceptions(
      () => _remoteDataSource.searchMovies(query: query, page: page),
    );
  }

  @override
  Future<Result<MovieDetail>> getMovieDetail(String imdbId) async {
    return _mapExceptions(() => _remoteDataSource.getMovieDetail(imdbId));
  }

  Future<Result<T>> _mapExceptions<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Success(result);
    } on ApiConfigurationException catch (error) {
      return ErrorResult(ApiConfigurationFailure(error.message));
    } on InvalidApiKeyException catch (error) {
      return ErrorResult(InvalidApiKeyFailure(error.message));
    } on NetworkException catch (error) {
      return ErrorResult(NetworkFailure(error.message));
    } on ParseException catch (error) {
      return ErrorResult(ParseFailure(error.message));
    } on ServerException catch (error) {
      return ErrorResult(
        ServerFailure(error.message, statusCode: error.statusCode),
      );
    } catch (_) {
      return const ErrorResult(UnexpectedFailure());
    }
  }
}
