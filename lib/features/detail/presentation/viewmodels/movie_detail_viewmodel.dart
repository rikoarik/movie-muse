import 'package:movie_muse/core/error/failures.dart';
import 'package:movie_muse/core/viewmodel/base_view_model.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/usecases/get_movie_detail_usecase.dart';

class MovieDetailViewModel extends BaseViewModel {
  MovieDetailViewModel({
    required this.imdbId,
    required this._getMovieDetailUseCase,
    this.initialSummary,
  });

  final String imdbId;
  final MovieSummary? initialSummary;
  final GetMovieDetailUseCase _getMovieDetailUseCase;

  MovieDetail? _detail;
  Failure? _failure;

  MovieDetail? get detail => _detail;
  Failure? get failure => _failure;
  bool get hasFallbackSummary => _detail == null && initialSummary != null;

  String get displayTitle =>
      _detail?.title ?? initialSummary?.title ?? 'Film details';
  String get displayYear => _detail?.year ?? initialSummary?.year ?? '';
  String? get displayPoster => _detail?.poster ?? initialSummary?.poster;
  String get displayMonogram =>
      _detail?.toSummary().monogram ?? initialSummary?.monogram ?? 'MV';

  MovieSummary? get favoritePayload => _detail?.toSummary() ?? initialSummary;

  bool get isMissingApiKey =>
      _failure is ApiConfigurationFailure || _failure is InvalidApiKeyFailure;

  Future<void> loadDetail() async {
    _failure = null;
    setState(ViewState.loading);

    final result = await _getMovieDetailUseCase(imdbId);
    result.fold(
      onSuccess: (movie) {
        _detail = movie;
        _failure = null;
        setState(ViewState.loaded);
      },
      onFailure: (failure) {
        _failure = failure;
        setState(ViewState.error, errorMessage: failure.message);
      },
    );
  }
}
