import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/core/usecase/usecase.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/repositories/favorites_repository.dart';

class GetFavoritesUseCase implements UseCase<List<MovieSummary>, NoParams> {
  const GetFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Result<List<MovieSummary>>> call(NoParams params) {
    return _repository.getFavorites();
  }
}
