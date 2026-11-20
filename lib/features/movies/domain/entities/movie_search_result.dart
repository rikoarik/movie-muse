import 'package:equatable/equatable.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';

class MovieSearchResult extends Equatable {
  const MovieSearchResult({required this.movies, required this.totalResults});

  final List<MovieSummary> movies;
  final int totalResults;

  @override
  List<Object?> get props => [movies, totalResults];
}
