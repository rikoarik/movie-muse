import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reelora/core/error/failures.dart';
import 'package:reelora/core/result/result.dart';
import 'package:reelora/core/usecase/usecase.dart';
import 'package:reelora/features/home/domain/entities/greeting.dart';
import 'package:reelora/features/home/domain/repositories/home_repository.dart';
import 'package:reelora/features/home/domain/usecases/get_greeting_usecase.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockHomeRepository repository;
  late GetGreetingUseCase useCase;

  setUp(() {
    repository = _MockHomeRepository();
    useCase = GetGreetingUseCase(repository);
  });

  test('returns Success<Greeting> when repository succeeds', () async {
    final greeting = Greeting(
      title: 'Welcome',
      subtitle: 'Ready',
      timestamp: DateTime(2026),
    );
    when(() => repository.getGreeting())
        .thenAnswer((_) async => Success(greeting));

    final result = await useCase(const NoParams());

    expect(result, isA<Success<Greeting>>());
    expect((result as Success<Greeting>).data, greeting);
    verify(() => repository.getGreeting()).called(1);
  });

  test('returns ErrorResult when repository fails', () async {
    when(
      () => repository.getGreeting(),
    ).thenAnswer((_) async => const ErrorResult(CacheFailure('Cache error')));

    final result = await useCase(const NoParams());

    expect(result, isA<ErrorResult<Greeting>>());
    expect(
      (result as ErrorResult<Greeting>).failure,
      const CacheFailure('Cache error'),
    );
  });
}
