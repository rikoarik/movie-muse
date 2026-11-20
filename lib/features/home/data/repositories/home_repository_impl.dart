import 'package:reelora/core/error/exceptions.dart';
import 'package:reelora/core/error/failures.dart';
import 'package:reelora/core/result/result.dart';
import 'package:reelora/features/home/data/datasources/home_local_datasource.dart';
import 'package:reelora/features/home/domain/entities/greeting.dart';
import 'package:reelora/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._localDataSource);

  final HomeLocalDataSource _localDataSource;

  @override
  Future<Result<Greeting>> getGreeting() async {
    try {
      final greeting = await _localDataSource.getGreeting();
      return Success(greeting);
    } on CacheException catch (error) {
      return ErrorResult(CacheFailure(error.message));
    } catch (_) {
      return const ErrorResult(UnexpectedFailure());
    }
  }
}
