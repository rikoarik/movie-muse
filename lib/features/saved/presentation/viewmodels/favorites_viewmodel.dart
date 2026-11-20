import 'package:movie_muse/core/usecase/usecase.dart';
import 'package:movie_muse/core/viewmodel/base_view_model.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/usecases/get_favorites_usecase.dart';
import 'package:movie_muse/features/movies/domain/usecases/toggle_favorite_usecase.dart';

class FavoritesViewModel extends BaseViewModel {
  FavoritesViewModel({
    required this._getFavoritesUseCase,
    required this._toggleFavoriteUseCase,
  });

  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  List<MovieSummary> _favorites = const [];
  Set<String> _favoriteIds = const {};
  String? _storageWarning;

  List<MovieSummary> get favorites => _favorites;
  Set<String> get favoriteIds => _favoriteIds;
  String? get storageWarning => _storageWarning;
  int get count => _favorites.length;

  bool isFavorite(String imdbId) => _favoriteIds.contains(imdbId);

  Future<void> load() async {
    setState(ViewState.loading);
    final result = await _getFavoritesUseCase(const NoParams());
    result.fold(
      onSuccess: (items) {
        _favorites = List<MovieSummary>.unmodifiable(items);
        _favoriteIds = items.map((item) => item.imdbId).toSet();
        _storageWarning = null;
        setState(ViewState.loaded);
      },
      onFailure: (failure) {
        _favorites = const [];
        _favoriteIds = const {};
        _storageWarning = failure.message;
        setState(ViewState.loaded);
      },
    );
  }

  Future<void> toggleFavorite(MovieSummary movie) async {
    final previousFavorites = _favorites;
    final previousIds = _favoriteIds;

    final optimistic = ToggleFavoriteUseCase.computeToggledFavorites(
      movie: movie,
      currentFavorites: previousFavorites,
    );
    _favorites = optimistic;
    _favoriteIds = optimistic.map((item) => item.imdbId).toSet();
    _storageWarning = null;
    safeNotifyListeners();

    final result = await _toggleFavoriteUseCase(
      ToggleFavoriteParams(movie: movie, currentFavorites: previousFavorites),
    );

    result.fold(
      onSuccess: (persisted) {
        _favorites = List<MovieSummary>.unmodifiable(persisted);
        _favoriteIds = persisted.map((item) => item.imdbId).toSet();
        _storageWarning = null;
        safeNotifyListeners();
      },
      onFailure: (failure) {
        _favorites = previousFavorites;
        _favoriteIds = previousIds;
        _storageWarning = failure.message;
        safeNotifyListeners();
      },
    );
  }
}
