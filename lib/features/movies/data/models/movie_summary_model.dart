import 'package:movie_muse/features/movies/data/models/omdb_normalizers.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';

class MovieSummaryModel extends MovieSummary {
  const MovieSummaryModel({
    required super.imdbId,
    required super.title,
    required super.year,
    super.poster,
    super.type,
  });

  factory MovieSummaryModel.fromEntity(MovieSummary entity) {
    return MovieSummaryModel(
      imdbId: entity.imdbId,
      title: entity.title,
      year: entity.year,
      poster: entity.poster,
      type: entity.type,
    );
  }

  static MovieSummaryModel? tryFromOmdbJson(Map<String, dynamic> json) {
    final imdbId = normalizeOmdbText(json['imdbID']);
    final title = normalizeOmdbText(json['Title']);
    if (imdbId == null || title == null) {
      return null;
    }

    return MovieSummaryModel(
      imdbId: imdbId,
      title: title,
      year: normalizeOmdbText(json['Year']) ?? 'Unknown year',
      poster: normalizeOmdbPoster(json['Poster']),
      type: normalizeOmdbText(json['Type']),
    );
  }

  static MovieSummaryModel? tryFromStorageJson(Map<String, dynamic> json) {
    final imdbId = normalizeOmdbText(json['imdbId']);
    final title = normalizeOmdbText(json['title']);
    if (imdbId == null || title == null) {
      return null;
    }

    return MovieSummaryModel(
      imdbId: imdbId,
      title: title,
      year: normalizeOmdbText(json['year']) ?? 'Unknown year',
      poster: normalizeOmdbPoster(json['poster']),
      type: normalizeOmdbText(json['type']),
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'imdbId': imdbId,
      'title': title,
      'year': year,
      'poster': poster,
      'type': type,
    };
  }

  MovieSummary toEntity() {
    return MovieSummary(
      imdbId: imdbId,
      title: title,
      year: year,
      poster: poster,
      type: type,
    );
  }
}
