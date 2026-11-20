import 'package:equatable/equatable.dart';
import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/core/usecase/usecase.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_search_result.dart';
import 'package:movie_muse/features/movies/domain/repositories/movie_repository.dart';

class SearchMoviesUseCase
    implements UseCase<MovieSearchResult, SearchMoviesParams> {
  const SearchMoviesUseCase(this._repository);

  final MovieRepository _repository;

  @override
  Future<Result<MovieSearchResult>> call(SearchMoviesParams params) {
    return _repository.searchMovies(query: params.query, page: params.page);
  }
}

final class SearchMoviesParams extends Equatable {
  const SearchMoviesParams({required this.query, this.page = 1});

  final String query;
  final int page;

  @override
  List<Object?> get props => [query, page];
}
