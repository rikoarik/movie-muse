import 'package:equatable/equatable.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';

class MovieDetail extends Equatable {
  const MovieDetail({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
    this.plot,
    this.genre,
    this.director,
    this.actors,
    this.runtime,
    this.imdbRating,
    this.released,
  });

  final String imdbId;
  final String title;
  final String year;
  final String? poster;
  final String? plot;
  final String? genre;
  final String? director;
  final String? actors;
  final String? runtime;
  final String? imdbRating;
  final String? released;

  List<String> get genreList {
    final value = genre;
    if (value == null || value.isEmpty) {
      return const [];
    }
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  List<String> get castList {
    final value = actors;
    if (value == null || value.isEmpty) {
      return const [];
    }
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  MovieSummary toSummary() {
    return MovieSummary(
      imdbId: imdbId,
      title: title,
      year: year,
      poster: poster,
      type: 'movie',
    );
  }

  @override
  List<Object?> get props => [
    imdbId,
    title,
    year,
    poster,
    plot,
    genre,
    director,
    actors,
    runtime,
    imdbRating,
    released,
  ];
}
