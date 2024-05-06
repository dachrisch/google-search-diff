import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_search_diff/_new/routes/routes.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());
  // Theme from: https://material-foundation.github.io/material-theme-builder/
  var theme = MaterialTheme(ThemeData.light().primaryTextTheme).light();

  SharedPreferences.getInstance()
      .then((prefs) => prefs.setInt('refreshEvery', 10))
      .then((value) =>
          SystemChrome.setPreferredOrientations(<DeviceOrientation>[
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ]).then((_) => runApp(RouterApp(
                theme: theme,
              ))));
}
