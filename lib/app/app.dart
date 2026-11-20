import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_muse/app/di/injection.dart';
import 'package:movie_muse/app/router/app_router.dart';
import 'package:movie_muse/app/theme/app_theme.dart';
import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/features/discover/presentation/viewmodels/discover_viewmodel.dart';
import 'package:movie_muse/features/saved/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:movie_muse/features/search/presentation/viewmodels/search_viewmodel.dart';
import 'package:movie_muse/features/shell/presentation/viewmodels/shell_viewmodel.dart';
import 'package:provider/provider.dart';

class MovieMuseApp extends StatefulWidget {
  const MovieMuseApp({super.key});

  @override
  State<MovieMuseApp> createState() => _MovieMuseAppState();
}

class _MovieMuseAppState extends State<MovieMuseApp> {
  late final GoRouter _router = createAppRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShellViewModel>.value(
          value: getIt<ShellViewModel>(),
        ),
        ChangeNotifierProvider<FavoritesViewModel>.value(
          value: getIt<FavoritesViewModel>(),
        ),
        ChangeNotifierProvider<DiscoverViewModel>.value(
          value: getIt<DiscoverViewModel>(),
        ),
        ChangeNotifierProvider<SearchViewModel>.value(
          value: getIt<SearchViewModel>(),
        ),
      ],
      child: MaterialApp.router(
        title: EnvConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
