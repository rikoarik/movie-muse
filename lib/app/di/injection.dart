import 'package:get_it/get_it.dart';
import 'package:reelora/core/network/api_client.dart';
import 'package:reelora/features/home/data/datasources/home_local_datasource.dart';
import 'package:reelora/features/home/data/repositories/home_repository_impl.dart';
import 'package:reelora/features/home/domain/repositories/home_repository.dart';
import 'package:reelora/features/home/domain/usecases/get_greeting_usecase.dart';
import 'package:reelora/features/home/presentation/viewmodels/home_viewmodel.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<ApiClient>()) {
    return;
  }

  // Core
  getIt.registerLazySingleton<ApiClient>(ApiClient.new);

  // Features - Home
  getIt.registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl.new);
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeLocalDataSource>()),
  );
  getIt.registerLazySingleton<GetGreetingUseCase>(
    () => GetGreetingUseCase(getIt<HomeRepository>()),
  );
  getIt.registerFactory<HomeViewModel>(
    () => HomeViewModel(getIt<GetGreetingUseCase>()),
  );
}
