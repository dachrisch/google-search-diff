import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/results_id.dart';
import 'package:google_search_diff/_new/page/queries_scaffold.dart';
import 'package:google_search_diff/_new/page/result_scaffold.dart';
import 'package:google_search_diff/_new/provider/results_scaffold_model.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/service/history_service.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class RouterApp extends StatelessWidget {
  final ThemeData theme;
  final QueriesStoreModel queriesStore;
  final SearchService searchService;
  final HistoryService historyService;

  RouterApp(
      {super.key,
      required this.theme,
      QueriesStoreModel? queriesStore,
      SearchService? searchService,
      HistoryService? historyService})
      : queriesStore = queriesStore ?? QueriesStoreModel(),
        searchService = searchService ?? LoremIpsumSearchService(),
        historyService = historyService ?? HistoryService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QueriesStoreModel>(
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

class RouterConfigBuilder {
  static build() => GoRouter(
        initialLocation: '/queries',
        routes: [
          GoRoute(path: '/', redirect: (context, state) => '/queries'),
          GoRoute(
              path: '/queries',
              builder: (context, state) => const QueriesScaffold(),
              routes: [
                GoRoute(
                  path: ':queryId',
                  redirect: (context, state) {
                    final queryId = state.pathParameters['queryId'];
                    return '/queries/$queryId/results';
                  },
                ),
                GoRoute(
                    path: ':queryId/results',
                    builder: (context, state) => Provider<QueryId>.value(
                        value: QueryId.fromState(state),
                        child: const ResultsScaffoldQueryModelProvider()),
                    routes: [
                      GoRoute(
                        path: ':resultsId',
                        builder: (context, state) => MultiProvider(providers: [
                          Provider<ResultsId>.value(
                              value: ResultsId.fromState(state)),
                          Provider<QueryId>.value(
                              value: QueryId.fromState(state))
                        ], child: ResultScaffoldResultsModelProvider()),
                      )
                    ])
              ]),
        ],
      );
}
