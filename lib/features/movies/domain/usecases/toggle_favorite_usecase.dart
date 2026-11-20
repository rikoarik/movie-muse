import 'package:equatable/equatable.dart';
import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/core/usecase/usecase.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/repositories/favorites_repository.dart';

class ToggleFavoriteUseCase
    implements UseCase<List<MovieSummary>, ToggleFavoriteParams> {
  const ToggleFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Result<List<MovieSummary>>> call(ToggleFavoriteParams params) {
    final nextFavorites = computeToggledFavorites(
      movie: params.movie,
      currentFavorites: params.currentFavorites,
    );
    return _repository.saveFavorites(nextFavorites);
  }

  static List<MovieSummary> computeToggledFavorites({
    required MovieSummary movie,
    required List<MovieSummary> currentFavorites,
  }) {
    final alreadySaved = currentFavorites.any(
      (item) => item.imdbId == movie.imdbId,
    );
    if (alreadySaved) {
      return currentFavorites
          .where((item) => item.imdbId != movie.imdbId)
          .toList(growable: false);
    }

    final seen = <String>{movie.imdbId};
    final result = <MovieSummary>[movie];
    for (final item in currentFavorites) {
      if (seen.add(item.imdbId)) {
        result.add(item);
      }
    }
    return List<MovieSummary>.unmodifiable(result);
  }
}

final class ToggleFavoriteParams extends Equatable {
  const ToggleFavoriteParams({
    required this.movie,
    required this.currentFavorites,
  });

  final MovieSummary movie;
  final List<MovieSummary> currentFavorites;

  @override
  List<Object?> get props => [movie, currentFavorites];
}
