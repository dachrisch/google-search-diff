import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/routes/routes.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());
  // Theme from: https://material-foundation.github.io/material-theme-builder/
  var theme = MaterialTheme(ThemeData.light().primaryTextTheme).light();

  var queriesStore = QueriesStoreModel();
  queriesStore.add(QueryModel(Query('Saved query 1'), results: [
    ResultsModel(Query('Saved query 1'), [ResultModel(title: 'result 1')])
  ]));

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
