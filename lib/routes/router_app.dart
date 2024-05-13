import 'package:flutter/material.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/routes/routes.dart';
import 'package:google_search_diff/service/history_service.dart';
import 'package:google_search_diff/service/search_service.dart';
import 'package:google_search_diff/theme.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

@injectable
class RouterApp extends StatelessWidget {
  final MaterialTheme theme;
  final QueriesStore queriesStore;
  final SearchService searchService;
  final HistoryService historyService;

  RouterApp(
      {required this.theme,
      required this.queriesStore,
      required this.searchService,
      required this.historyService})
      : super(key: GlobalKey());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QueriesStore>(
            create: (BuildContext context) => queriesStore),
        Provider<SearchService>(
          create: (BuildContext context) => searchService,
        ),
        ChangeNotifierProvider<HistoryService>(
          create: (BuildContext context) => historyService,
        )
      ],
      child: MaterialApp.router(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          RelativeTimeLocalizations.delegate,
        ],
        theme: theme.light(),
        routerConfig: RouterConfigBuilder.build(),
      ),
    );
  }
}
