import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_search_diff/_new/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const RouterApp()));
}
