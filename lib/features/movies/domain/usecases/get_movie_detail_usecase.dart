import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/core/usecase/usecase.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_muse/features/movies/domain/repositories/movie_repository.dart';

class GetMovieDetailUseCase implements UseCase<MovieDetail, String> {
  const GetMovieDetailUseCase(this._repository);

  final MovieRepository _repository;

  @override
  Future<Result<MovieDetail>> call(String imdbId) {
    return _repository.getMovieDetail(imdbId);
  }
}
