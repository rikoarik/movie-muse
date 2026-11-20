import 'package:go_router/go_router.dart';
import 'package:movie_muse/app/di/injection.dart';
import 'package:movie_muse/app/router/app_routes.dart';
import 'package:movie_muse/features/detail/presentation/viewmodels/movie_detail_viewmodel.dart';
import 'package:movie_muse/features/detail/presentation/views/movie_detail_view.dart';
import 'package:movie_muse/features/movies/domain/usecases/get_movie_detail_usecase.dart';
import 'package:movie_muse/features/shell/presentation/views/main_shell_view.dart';
import 'package:provider/provider.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.shell,
    routes: [
      GoRoute(
        path: AppRoutes.shell,
        builder: (context, state) => const MainShellView(),
      ),
      GoRoute(
        path: AppRoutes.movieDetailPattern,
        builder: (context, state) {
          final imdbId = Uri.decodeComponent(
            state.pathParameters['imdbId'] ?? '',
          );
          final extra = state.extra is MovieDetailRouteExtra
              ? state.extra! as MovieDetailRouteExtra
              : null;

          return ChangeNotifierProvider<MovieDetailViewModel>(
            create: (_) => MovieDetailViewModel(
              imdbId: imdbId,
              initialSummary: extra?.summary,
              getMovieDetailUseCase: getIt<GetMovieDetailUseCase>(),
            ),
            child: MovieDetailView(heroTag: extra?.heroTag),
          );
        },
      ),
    ],
  );
}
