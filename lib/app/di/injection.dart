import 'package:get_it/get_it.dart';
import 'package:movie_muse/core/network/api_client.dart';
import 'package:movie_muse/features/discover/presentation/viewmodels/discover_viewmodel.dart';
import 'package:movie_muse/features/movies/data/datasources/favorites_local_datasource.dart';
import 'package:movie_muse/features/movies/data/datasources/omdb_remote_datasource.dart';
import 'package:movie_muse/features/movies/data/repositories/favorites_repository_impl.dart';
import 'package:movie_muse/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:movie_muse/features/movies/domain/repositories/favorites_repository.dart';
import 'package:movie_muse/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_muse/features/movies/domain/usecases/get_favorites_usecase.dart';
import 'package:movie_muse/features/movies/domain/usecases/get_movie_detail_usecase.dart';
import 'package:movie_muse/features/movies/domain/usecases/search_movies_usecase.dart';
import 'package:movie_muse/features/movies/domain/usecases/toggle_favorite_usecase.dart';
import 'package:movie_muse/features/saved/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:movie_muse/features/search/presentation/viewmodels/search_viewmodel.dart';
import 'package:movie_muse/features/shell/presentation/viewmodels/shell_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies({
  SharedPreferences? sharedPreferences,
  MovieRepository? movieRepository,
  FavoritesRepository? favoritesRepository,
  Duration? searchDebounceDuration,
}) async {
  if (getIt.isRegistered<FavoritesViewModel>()) {
    return;
  }

  final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Core
  getIt.registerLazySingleton<ApiClient>(ApiClient.new);

  // DataSources
  getIt.registerLazySingleton<OmdbRemoteDataSource>(
    () => OmdbRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Repositories
  getIt.registerLazySingleton<MovieRepository>(
    () => movieRepository ?? MovieRepositoryImpl(getIt<OmdbRemoteDataSource>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () =>
        favoritesRepository ??
        FavoritesRepositoryImpl(getIt<FavoritesLocalDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton<SearchMoviesUseCase>(
    () => SearchMoviesUseCase(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<GetMovieDetailUseCase>(
    () => GetMovieDetailUseCase(getIt<MovieRepository>()),
  );
  getIt.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(getIt<FavoritesRepository>()),
  );
  getIt.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(getIt<FavoritesRepository>()),
  );

  // ViewModels (shared across Shell tabs)
  getIt.registerLazySingleton<ShellViewModel>(ShellViewModel.new);
  getIt.registerLazySingleton<FavoritesViewModel>(
    () => FavoritesViewModel(
      getFavoritesUseCase: getIt<GetFavoritesUseCase>(),
      toggleFavoriteUseCase: getIt<ToggleFavoriteUseCase>(),
    ),
  );
  getIt.registerLazySingleton<DiscoverViewModel>(
    () => DiscoverViewModel(
      searchMoviesUseCase: getIt<SearchMoviesUseCase>(),
      getMovieDetailUseCase: getIt<GetMovieDetailUseCase>(),
    ),
  );
  getIt.registerLazySingleton<SearchViewModel>(
    () => SearchViewModel(
      searchMoviesUseCase: getIt<SearchMoviesUseCase>(),
      debounceDuration:
          searchDebounceDuration ?? const Duration(milliseconds: 450),
    ),
  );
}

Future<void> resetDependencies() async {
  await getIt.reset();
}
