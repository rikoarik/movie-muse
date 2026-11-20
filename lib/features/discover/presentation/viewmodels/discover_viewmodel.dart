import 'dart:async';

import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/core/error/failures.dart';
import 'package:movie_muse/core/viewmodel/base_view_model.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/usecases/get_movie_detail_usecase.dart';
import 'package:movie_muse/features/movies/domain/usecases/search_movies_usecase.dart';

class DiscoverViewModel extends BaseViewModel {
  DiscoverViewModel({
    required this._searchMoviesUseCase,
    required this._getMovieDetailUseCase,
  });

  final SearchMoviesUseCase _searchMoviesUseCase;
  final GetMovieDetailUseCase _getMovieDetailUseCase;

  String _activeQuery = EnvConfig.defaultDiscoverQuery;
  List<MovieSummary> _movies = const [];
  MovieDetail? _featuredDetail;
  int _totalResults = 0;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  Failure? _failure;
  int _requestGeneration = 0;

  String get activeQuery => _activeQuery;
  List<MovieSummary> get movies => _movies;
  MovieSummary? get featuredMovie => _movies.isNotEmpty ? _movies.first : null;
  MovieDetail? get featuredDetail => _featuredDetail;
  List<MovieSummary> get listMovies =>
      _movies.length > 1 ? _movies.sublist(1) : _movies;
  int get totalResults => _totalResults;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _movies.length < _totalResults;
  Failure? get failure => _failure;
  bool get isMissingApiKey =>
      _failure is ApiConfigurationFailure || _failure is InvalidApiKeyFailure;

  Future<void> initializeIfNeeded() async {
    if (state == ViewState.initial) {
      await loadMovies();
    }
  }

  Future<void> selectQuery(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty ||
        normalized == _activeQuery && _movies.isNotEmpty) {
      return;
    }
    _activeQuery = normalized;
    await loadMovies();
  }

  Future<void> loadMovies() async {
    final generation = ++_requestGeneration;
    _currentPage = 1;
    _isLoadingMore = false;
    _featuredDetail = null;
    _failure = null;
    setState(ViewState.loading);

    final result = await _searchMoviesUseCase(
      SearchMoviesParams(query: _activeQuery),
    );
    if (generation != _requestGeneration) {
      return;
    }

    result.fold(
      onSuccess: (data) {
        _movies = data.movies;
        _totalResults = data.totalResults;
        _failure = null;
        setState(ViewState.loaded);
        if (data.movies.isNotEmpty) {
          unawaited(_loadFeaturedDetail(data.movies.first.imdbId, generation));
        }
      },
      onFailure: (failure) {
        _movies = const [];
        _totalResults = 0;
        _failure = failure;
        setState(ViewState.error, errorMessage: failure.message);
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || isLoading || !hasMore) {
      return;
    }

    final generation = _requestGeneration;
    final nextPage = _currentPage + 1;
    _isLoadingMore = true;
    safeNotifyListeners();

    final result = await _searchMoviesUseCase(
      SearchMoviesParams(query: _activeQuery, page: nextPage),
    );
    if (generation != _requestGeneration) {
      return;
    }

    _isLoadingMore = false;
    result.fold(
      onSuccess: (data) {
        _currentPage = nextPage;
        final existingIds = _movies.map((m) => m.imdbId).toSet();
        final merged = [
          ..._movies,
          ...data.movies.where((m) => existingIds.add(m.imdbId)),
        ];
        _movies = List<MovieSummary>.unmodifiable(merged);
        _totalResults = data.totalResults;
        safeNotifyListeners();
      },
      onFailure: (_) {
        safeNotifyListeners();
      },
    );
  }

  Future<void> _loadFeaturedDetail(String imdbId, int generation) async {
    final result = await _getMovieDetailUseCase(imdbId);
    if (generation != _requestGeneration) {
      return;
    }
    result.fold(
      onSuccess: (detail) {
        _featuredDetail = detail;
        safeNotifyListeners();
      },
      onFailure: (_) {},
    );
  }
}
