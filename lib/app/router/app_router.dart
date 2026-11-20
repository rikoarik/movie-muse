import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reelora/app/di/injection.dart';
import 'package:reelora/app/router/app_routes.dart';
import 'package:reelora/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:reelora/features/home/presentation/views/home_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return ChangeNotifierProvider<HomeViewModel>(
          create: (_) => getIt<HomeViewModel>(),
          child: const HomeView(),
        );
      },
    ),
  ],
);
