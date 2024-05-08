import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/routes/routes.dart';
import 'package:google_search_diff/_new/service/history_service.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class RouterApp extends StatelessWidget {
  final ThemeData theme;
  final QueriesStore queriesStore;
  final SearchService searchService;
  final HistoryService historyService;

  RouterApp(
      {super.key,
      required this.theme,
      QueriesStore? queriesStore,
      SearchService? searchService,
      HistoryService? historyService})
      : queriesStore = queriesStore ?? QueriesStore(),
        searchService = searchService ?? LoremIpsumSearchService(),
        historyService = historyService ?? HistoryService();

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
        theme: theme,
        routerConfig: RouterConfigBuilder.build(),
      ),
    );
  }
}
