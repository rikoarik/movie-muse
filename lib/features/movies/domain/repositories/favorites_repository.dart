import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';

abstract interface class FavoritesRepository {
  Future<Result<List<MovieSummary>>> getFavorites();

  Future<Result<List<MovieSummary>>> saveFavorites(
    List<MovieSummary> favorites,
  );
}
