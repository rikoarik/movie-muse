import 'package:flutter_test/flutter_test.dart';
import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/core/error/failures.dart';
import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/features/movies/data/datasources/favorites_local_datasource.dart';
import 'package:movie_muse/features/movies/data/repositories/favorites_repository_impl.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/usecases/toggle_favorite_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const batmanBegins = MovieSummary(
    imdbId: 'tt0372784',
    title: 'Batman Begins',
    year: '2005',
    type: 'movie',
  );
  const interstellar = MovieSummary(
    imdbId: 'tt0816692',
    title: 'Interstellar',
    year: '2014',
    type: 'movie',
  );

  test(
    'saves newest-first, deduplicates, removes, and reloads across restarts',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = FavoritesRepositoryImpl(FavoritesLocalDataSourceImpl(prefs));
      final toggleUseCase = ToggleFavoriteUseCase(repo);

      final firstSave = await toggleUseCase(
        const ToggleFavoriteParams(movie: batmanBegins, currentFavorites: []),
      );
      expect(firstSave, isA<Success<List<MovieSummary>>>());
      var saved = (firstSave as Success<List<MovieSummary>>).data;
      expect(saved, [batmanBegins]);

      final secondSave = await toggleUseCase(
        ToggleFavoriteParams(movie: interstellar, currentFavorites: saved),
      );
      saved = (secondSave as Success<List<MovieSummary>>).data;
      expect(saved, [interstellar, batmanBegins]);

      // Reload via fresh repository instance backed by same persisted store.
      final reloadedPrefs = await SharedPreferences.getInstance();
      final reloadedRepo = FavoritesRepositoryImpl(
        FavoritesLocalDataSourceImpl(reloadedPrefs),
      );
      final reloadedResult = await reloadedRepo.getFavorites();
      expect(reloadedResult, isA<Success<List<MovieSummary>>>());
      expect((reloadedResult as Success<List<MovieSummary>>).data, [
        interstellar,
        batmanBegins,
      ]);

      // Toggle existing item removes it cleanly.
      final removedResult = await toggleUseCase(
        ToggleFavoriteParams(movie: batmanBegins, currentFavorites: saved),
      );
      expect((removedResult as Success<List<MovieSummary>>).data, [
        interstellar,
      ]);
    },
  );

  test('returns CacheFailure safely when stored JSON is malformed', () async {
    SharedPreferences.setMockInitialValues({
      EnvConfig.favoritesStorageKey: '{corrupted-json',
    });
    final prefs = await SharedPreferences.getInstance();
    final repo = FavoritesRepositoryImpl(FavoritesLocalDataSourceImpl(prefs));

    final result = await repo.getFavorites();

    expect(result, isA<ErrorResult<List<MovieSummary>>>());
    expect(
      (result as ErrorResult<List<MovieSummary>>).failure,
      isA<CacheFailure>(),
    );
  });
}
