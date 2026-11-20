import 'dart:async';

import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/core/error/failures.dart';
import 'package:movie_muse/core/viewmodel/base_view_model.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/usecases/search_movies_usecase.dart';

enum SearchStatus { idle, loading, results, empty, error, missingApiKey }

class SearchViewModel extends BaseViewModel {
  SearchViewModel({
    required this._searchMoviesUseCase,
    this._debounceDuration = EnvConfig.searchDebounce,
  });

  final SearchMoviesUseCase _searchMoviesUseCase;
  final Duration _debounceDuration;

  Timer? _debounceTimer;
  int _requestGeneration = 0;

  SearchStatus _status = SearchStatus.idle;
  String _query = '';
  String _activeSearchedQuery = '';
  List<MovieSummary> _results = const [];
  int _totalResults = 0;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  Failure? _failure;

  SearchStatus get status => _status;
  String get query => _query;
  String get activeSearchedQuery => _activeSearchedQuery;
  List<MovieSummary> get results => _results;
  int get totalResults => _totalResults;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _results.length < _totalResults;
  Failure? get failure => _failure;

  void onQueryChanged(String value) {
    _debounceTimer?.cancel();
    _requestGeneration++;
    _query = value;

    final normalized = value.trim();
    if (normalized.length < EnvConfig.minSearchLength) {
      _activeSearchedQuery = '';
      _results = const [];
      _totalResults = 0;
      _currentPage = 1;
      _isLoadingMore = false;
      _failure = null;
      _status = SearchStatus.idle;
      setState(ViewState.initial);
      return;
    }

    final capturedGeneration = _requestGeneration;
    _debounceTimer = Timer(_debounceDuration, () {
      unawaited(_executeSearch(normalized, capturedGeneration));
    });
  }

  Future<void> submitSearch(String value) async {
    _debounceTimer?.cancel();
    final generation = ++_requestGeneration;
    _query = value;
    final normalized = value.trim();

    if (normalized.length < EnvConfig.minSearchLength) {
      _activeSearchedQuery = '';
      _results = const [];
      _totalResults = 0;
      _failure = null;
      _status = SearchStatus.idle;
      setState(ViewState.initial);
      return;
    }

    await _executeSearch(normalized, generation);
  }

  Future<void> retry() async {
    final normalized = _query.trim();
    if (normalized.length < EnvConfig.minSearchLength) {
      return;
    }
    final generation = ++_requestGeneration;
    await _executeSearch(normalized, generation);
  }

  void clear() {
    _debounceTimer?.cancel();
    _requestGeneration++;
    _query = '';
    _activeSearchedQuery = '';
    _results = const [];
    _totalResults = 0;
    _currentPage = 1;
    _isLoadingMore = false;
    _failure = null;
    _status = SearchStatus.idle;
    setState(ViewState.initial);
  }

  Future<void> loadMore() async {
    if (_isLoadingMore ||
        _status != SearchStatus.results ||
        !hasMore ||
        _activeSearchedQuery.isEmpty) {
      return;
    }

    final capturedGeneration = _requestGeneration;
    final nextPage = _currentPage + 1;
    _isLoadingMore = true;
    safeNotifyListeners();

    final result = await _searchMoviesUseCase(
      SearchMoviesParams(query: _activeSearchedQuery, page: nextPage),
    );
    if (capturedGeneration != _requestGeneration) {
      return;
    }

    _isLoadingMore = false;
    result.fold(
      onSuccess: (data) {
        _currentPage = nextPage;
        final existingIds = _results.map((m) => m.imdbId).toSet();
        final merged = [
          ..._results,
          ...data.movies.where((m) => existingIds.add(m.imdbId)),
        ];
        _results = List<MovieSummary>.unmodifiable(merged);
        _totalResults = data.totalResults;
        safeNotifyListeners();
      },
      onFailure: (_) {
        safeNotifyListeners();
      },
    );
  }

  Future<void> _executeSearch(String normalizedQuery, int generation) async {
    _activeSearchedQuery = normalizedQuery;
    _currentPage = 1;
    _isLoadingMore = false;
    _failure = null;
    _status = SearchStatus.loading;
    setState(ViewState.loading);

    final result = await _searchMoviesUseCase(
      SearchMoviesParams(query: normalizedQuery),
    );
    if (generation != _requestGeneration) {
      return;
    }

    result.fold(
      onSuccess: (data) {
        _results = data.movies;
        _totalResults = data.totalResults;
        _failure = null;
        _status = data.movies.isEmpty
            ? SearchStatus.empty
            : SearchStatus.results;
        setState(ViewState.loaded);
      },
      onFailure: (failure) {
        _results = const [];
        _totalResults = 0;
        _failure = failure;
        _status =
            (failure is ApiConfigurationFailure ||
                failure is InvalidApiKeyFailure)
            ? SearchStatus.missingApiKey
            : SearchStatus.error;
        setState(ViewState.error, errorMessage: failure.message);
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
