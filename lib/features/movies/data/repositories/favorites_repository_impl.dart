import 'package:movie_muse/core/error/exceptions.dart';
import 'package:movie_muse/core/error/failures.dart';
import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/features/movies/data/datasources/favorites_local_datasource.dart';
import 'package:movie_muse/features/movies/data/models/movie_summary_model.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<Result<List<MovieSummary>>> getFavorites() async {
    try {
      final favorites = await _localDataSource.getFavorites();
      return Success(
        List<MovieSummary>.unmodifiable(
          favorites.map((item) => item.toEntity()),
        ),
      );
    } on CacheException catch (error) {
      return ErrorResult(CacheFailure(error.message));
    } catch (_) {
      return const ErrorResult(CacheFailure());
    }
  }

  @override
  Future<Result<List<MovieSummary>>> saveFavorites(
    List<MovieSummary> favorites,
  ) async {
    try {
      final models = favorites.map(MovieSummaryModel.fromEntity).toList();
      final persisted = await _localDataSource.saveFavorites(models);
      return Success(
        List<MovieSummary>.unmodifiable(
          persisted.map((item) => item.toEntity()),
        ),
      );
    } on CacheException catch (error) {
      return ErrorResult(CacheFailure(error.message));
    } catch (_) {
      return const ErrorResult(CacheFailure());
    }
  }
}
