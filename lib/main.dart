import 'package:flutter/material.dart';
import 'package:reelora/app/app.dart';
import 'package:reelora/app/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ReeloraApp());
}
