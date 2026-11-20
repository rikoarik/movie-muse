import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';

abstract final class AppRoutes {
  static const String shell = '/';
  static const String movieDetailPattern = '/movie/:imdbId';

  static String movieDetailPath(String imdbId) {
    return '/movie/${Uri.encodeComponent(imdbId)}';
  }
}

final class MovieDetailRouteExtra {
  const MovieDetailRouteExtra({this.summary, this.heroTag});

  final MovieSummary? summary;
  final String? heroTag;
}
