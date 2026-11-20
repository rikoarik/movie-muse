import 'package:movie_muse/core/error/exceptions.dart';
import 'package:movie_muse/features/movies/data/models/omdb_normalizers.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.imdbId,
    required super.title,
    required super.year,
    super.poster,
    super.plot,
    super.genre,
    super.director,
    super.actors,
    super.runtime,
    super.imdbRating,
    super.released,
  });

  factory MovieDetailModel.fromOmdbJson(Map<String, dynamic> json) {
    final imdbId = normalizeOmdbText(json['imdbID']);
    final title = normalizeOmdbText(json['Title']);
    if (imdbId == null || title == null) {
      throw const ParseException('Movie detail is missing mandatory fields.');
    }

    return MovieDetailModel(
      imdbId: imdbId,
      title: title,
      year: normalizeOmdbText(json['Year']) ?? 'Unknown year',
      poster: normalizeOmdbPoster(json['Poster']),
      plot: normalizeOmdbText(json['Plot']),
      genre: normalizeOmdbText(json['Genre']),
      director: normalizeOmdbText(json['Director']),
      actors: normalizeOmdbText(json['Actors']),
      runtime: normalizeOmdbText(json['Runtime']),
      imdbRating: normalizeOmdbText(json['imdbRating']),
      released: normalizeOmdbText(json['Released']),
    );
  }
}
