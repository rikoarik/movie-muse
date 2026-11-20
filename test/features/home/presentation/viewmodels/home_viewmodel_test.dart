import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reelora/core/error/failures.dart';
import 'package:reelora/core/result/result.dart';
import 'package:reelora/core/usecase/usecase.dart';
import 'package:reelora/core/viewmodel/base_view_model.dart';
import 'package:reelora/features/home/domain/entities/greeting.dart';
import 'package:reelora/features/home/domain/usecases/get_greeting_usecase.dart';
import 'package:reelora/features/home/presentation/viewmodels/home_viewmodel.dart';

class _MockGetGreetingUseCase extends Mock implements GetGreetingUseCase {}

void main() {
  late _MockGetGreetingUseCase getGreetingUseCase;
  late HomeViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getGreetingUseCase = _MockGetGreetingUseCase();
    viewModel = HomeViewModel(getGreetingUseCase);
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('loads greeting and updates state to loaded', () async {
    final greeting = Greeting(
      title: 'Welcome to Reelora',
      subtitle: 'Clean Architecture',
      timestamp: DateTime(2026),
    );
    when(() => getGreetingUseCase(any()))
        .thenAnswer((_) async => Success(greeting));

    await viewModel.loadGreeting();

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.greeting, greeting);
    expect(viewModel.errorMessage, isNull);
  });

  test('updates state to error when use case returns failure', () async {
    when(() => getGreetingUseCase(any()))
        .thenAnswer((_) async => const ErrorResult(NetworkFailure()));

    await viewModel.loadGreeting();

    expect(viewModel.state, ViewState.error);
    expect(viewModel.errorMessage, 'No internet connection.');
  });
}
