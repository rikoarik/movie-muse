import 'package:reelora/features/home/data/models/greeting_model.dart';

abstract interface class HomeLocalDataSource {
  Future<GreetingModel> getGreeting();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  const HomeLocalDataSourceImpl();

  @override
  Future<GreetingModel> getGreeting() async {
    return GreetingModel(
      title: 'Welcome to Reelora',
      subtitle: 'Flutter MVVM + Clean Architecture starter is ready.',
      timestamp: DateTime.now(),
    );
  }
}
