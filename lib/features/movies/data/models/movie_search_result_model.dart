import 'package:movie_muse/features/movies/data/models/movie_summary_model.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_search_result.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';

class MovieSearchResultModel extends MovieSearchResult {
  const MovieSearchResultModel({
    required super.movies,
    required super.totalResults,
  });

  factory MovieSearchResultModel.fromOmdbJson(Map<String, dynamic> json) {
    final rawList = json['Search'];
    final movies = <MovieSummary>[];
    final seenIds = <String>{};

    if (rawList is List) {
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          final parsed = MovieSummaryModel.tryFromOmdbJson(item);
          if (parsed != null && seenIds.add(parsed.imdbId)) {
            movies.add(parsed);
          }
        } else if (item is Map) {
          final mapped = item.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          final parsed = MovieSummaryModel.tryFromOmdbJson(mapped);
          if (parsed != null && seenIds.add(parsed.imdbId)) {
            movies.add(parsed);
          }
        }
      }
    }

    final rawTotal = json['totalResults'];
    final totalResults = switch (rawTotal) {
      final int value => value,
      final String value => int.tryParse(value.trim()) ?? movies.length,
      _ => movies.length,
    };

    return MovieSearchResultModel(
      movies: List<MovieSummary>.unmodifiable(movies),
      totalResults: totalResults < 0 ? 0 : totalResults,
    );
  }
}
