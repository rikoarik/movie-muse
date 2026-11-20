import 'package:reelora/core/result/result.dart';
import 'package:reelora/core/usecase/usecase.dart';
import 'package:reelora/features/home/domain/entities/greeting.dart';
import 'package:reelora/features/home/domain/repositories/home_repository.dart';

class GetGreetingUseCase implements UseCase<Greeting, NoParams> {
  const GetGreetingUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<Greeting>> call(NoParams params) {
    return _repository.getGreeting();
  }
}
