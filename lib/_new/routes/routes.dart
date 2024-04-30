import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/page/queries_scaffold.dart';
import 'package:google_search_diff/_new/provider/query_scaffold_model.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:provider/provider.dart';

class RouterApp extends StatelessWidget {
  final ThemeData theme;

  const RouterApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QueriesStoreModel>(
            create: (BuildContext context) => QueriesStoreModel()),
      ],
      child: MaterialApp.router(
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
          GoRoute(
              path: '/queries',
              builder: (context, state) => const QueriesScaffold(),
              routes: [
                GoRoute(
                  path: ':queryId',
                  builder: (context, state) => Provider<QueryId>.value(
                      value: QueryId.fromState(state),
                      child: const QueryScaffoldQueryModelProvider()),
                )
              ]),
        ],
      );
}
