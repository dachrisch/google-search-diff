import 'package:go_router/go_router.dart';
import 'package:google_search_diff/model/run_id.dart';
import 'package:google_search_diff/page/comparison.dart';
import 'package:google_search_diff/page/comparison_test.dart';
import 'package:google_search_diff/page/queries_page.dart';
import 'package:google_search_diff/page/query_runs.dart';
import 'package:google_search_diff/page/query_runs_test.dart';
import 'package:google_search_diff/page/results_page.dart';
import 'package:google_search_diff/routes/query_id.dart';
import 'package:google_search_diff/widget/model/comparison.dart';
import 'package:provider/provider.dart';

class RouterConfigBuilder {
  static build() => GoRouter(
        initialLocation: '/queries',
        routes: [
          GoRoute(path: '/', redirect: (context, state) => '/queries'),
          GoRoute(
              path: '/queries',
              builder: (context, state) => const QueriesPage(),
              routes: [
                GoRoute(
                  path: ':queryId',
                  redirect: (context, state) {
                    final queryId = state.pathParameters['queryId'];
                    return '/queries/$queryId/runs';
                  },
                ),
                GoRoute(
                    path: ':queryId/runs',
                    builder: (context, state) => Provider<QueryId>.value(
                        value: QueryId.fromState(state),
                        child: const QueryRunsPage()),
                    routes: [
                      GoRoute(
                        path: ':runId',
                        builder: (context, state) => MultiProvider(providers: [
                          Provider<RunId>.value(
                              value: RunId.fromState(state, 'runId')),
                          Provider<QueryId>.value(
                              value: QueryId.fromState(state))
                        ], child: const ResultsPage()),
                      )
                    ])
              ]),
          GoRoute(
              path: '/tests/comparison',
              builder: (context, state) => const ComparisonPageTest()),
          GoRoute(
              path: '/tests/run/comparison',
              builder: (context, state) => const RunComparisonPageTest()),
          GoRoute(
            path: '/compare/:baseId/with/:currentId',
            builder: (context, state) => MultiProvider(providers: [
              Provider<BaseRunId>.value(value: BaseRunId(state)),
              Provider<CurrentRunId>.value(value: CurrentRunId(state))
            ], child: const ComparisonPageProvider()),
          )
        ],
      );
}
