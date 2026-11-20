import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_muse/app/app.dart';
import 'package:movie_muse/app/di/injection.dart';
import 'package:movie_muse/features/saved/presentation/viewmodels/favorites_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await configureDependencies();
  await getIt<FavoritesViewModel>().load();
  runApp(const MovieMuseApp());
}
