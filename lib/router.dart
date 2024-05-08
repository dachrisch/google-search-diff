import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/routes/router_app.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Theme from: https://material-foundation.github.io/material-theme-builder/
  var theme = MaterialTheme(ThemeData.light().primaryTextTheme).light();

  var queriesStore = QueriesStore();
  await queriesStore.add(QueryRuns.fromRun(
      Run(Query('Saved query 1'), [Result(title: 'result 1')])));

  SharedPreferences.getInstance()
      .then((prefs) => prefs.setInt('refreshEvery', 10))
      .then((value) =>
          SystemChrome.setPreferredOrientations(<DeviceOrientation>[
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ]).then((_) => runApp(RouterApp(
                theme: theme,
                queriesStore: queriesStore,
              ))));
}
