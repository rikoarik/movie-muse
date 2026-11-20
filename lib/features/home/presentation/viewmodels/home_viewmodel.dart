import 'package:reelora/core/usecase/usecase.dart';
import 'package:reelora/core/viewmodel/base_view_model.dart';
import 'package:reelora/features/home/domain/entities/greeting.dart';
import 'package:reelora/features/home/domain/usecases/get_greeting_usecase.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._getGreetingUseCase);

  final GetGreetingUseCase _getGreetingUseCase;

  Greeting? _greeting;
  Greeting? get greeting => _greeting;

  Future<void> loadGreeting() async {
    setState(ViewState.loading);

    final result = await _getGreetingUseCase(const NoParams());
    result.fold(
      onSuccess: (data) {
        _greeting = data;
        setState(ViewState.loaded);
      },
      onFailure: (failure) {
        setState(ViewState.error, errorMessage: failure.message);
      },
    );
  }
}
