import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/dependencies.dart';
import 'package:google_search_diff/_new/routes/router_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  RouterApp routerApp = getIt<RouterApp>();

  SharedPreferences.getInstance()
      .then((prefs) => prefs.setInt('refreshEvery', 10))
      .then((_) => runApp(routerApp));
}

