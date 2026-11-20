import 'package:flutter/material.dart';
import 'package:reelora/app/router/app_router.dart';
import 'package:reelora/app/theme/app_theme.dart';
import 'package:reelora/core/config/env_config.dart';

class ReeloraApp extends StatelessWidget {
  const ReeloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: EnvConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
