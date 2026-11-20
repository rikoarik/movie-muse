import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_search_result.dart';

abstract interface class MovieRepository {
  Future<Result<MovieSearchResult>> searchMovies({
    required String query,
    int page = 1,
  });

  Future<Result<MovieDetail>> getMovieDetail(String imdbId);
}
