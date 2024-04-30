import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/searchQueryStore.dart';
import 'package:google_search_diff/_new/provider/singleQueryModelProvider.dart';
import 'package:google_search_diff/_new/page/singleQueryScaffold.dart';
import 'package:google_search_diff/_new/routes/queryId.dart';
import 'package:google_search_diff/_new/page/allQueriesScaffold.dart';
import 'package:google_search_diff/main.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RouterApp extends StatelessWidget {
  const RouterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchQueriesStore>(
            create: (BuildContext context) => SearchQueriesStore()),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleSearchDiffScreenTheme.buildLightTheme().textTheme,
          platform: TargetPlatform.iOS,
        ),
        routerConfig: RouterConfigBuilder.build(),
      ),
    );
  }
}

class RouterConfigBuilder {
  static build() => GoRouter(
        initialLocation: '/queries',
        routes: [
          GoRoute(
              path: '/queries',
              builder: (context, state) => const AllQueriesScaffold(),
              routes: [
                GoRoute(
                  path: ':queryId',
                  builder: (context, state) => Provider<QueryId>.value(
                      value: QueryId.fromState(state),
                      child: const SingleQueryModelProvider()),
                )
              ]),
        ],
      );
}

