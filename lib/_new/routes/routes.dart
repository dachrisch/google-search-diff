import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/page/queries_scaffold.dart';
import 'package:google_search_diff/_new/provider/query_scaffold_model.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:provider/provider.dart';
class ResultModel {
  final String title;
  final String source;
  final String link;
  final String snippet;

  ResultModel({required this.title,  this.source='', this.link='',  this.snippet=''});
}
class Query {
  final String query;
  Query(this. query);
}

class RouterApp extends StatelessWidget {
  final ThemeData theme;

  const RouterApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QueriesStoreModel>(
            create: (BuildContext context) => QueriesStoreModel()),
        Provider<SearchService>(create: (BuildContext context) => LoremIpsumSearchService(),)
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
