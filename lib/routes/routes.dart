import 'package:go_router/go_router.dart';
import 'package:google_search_diff/model/result_id.dart';
import 'package:google_search_diff/model/run_id.dart';
import 'package:google_search_diff/routes/query_id.dart';
import 'package:google_search_diff/widget/comparison/comparison_page.dart';
import 'package:google_search_diff/widget/comparison/comparison_test.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:google_search_diff/widget/queries/queries_page.dart';
import 'package:google_search_diff/widget/results/results_page.dart';
import 'package:google_search_diff/widget/results/timeline/result_test_page.dart';
import 'package:google_search_diff/widget/results/timeline/result_timeline_page.dart';
import 'package:google_search_diff/widget/runs/query_runs_page.dart';
import 'package:google_search_diff/widget/runs/query_runs_test.dart';
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
                    builder: (context, state) => Provider<QueryId>(
                        create: (_) => QueryId.fromState(state),
                        child: const QueryRunsPage()),
                    routes: [
                      GoRoute(
                        path: ':runId',
                        redirect: (context, state) {
                          final queryId = state.pathParameters['queryId'];
                          final runId = state.pathParameters['runId'];
                          return '/queries/$queryId/runs/$runId/results';
                        },
                      ),
                      GoRoute(
                          path: ':runId/results',
                          builder: (context, state) =>
                              MultiProvider(providers: [
                                Provider<RunId>(
                                    create: (_) =>
                                        RunId.fromState(state, 'runId')),
                                Provider<QueryId>(
                                    create: (_) => QueryId.fromState(state))
                              ], child: const ResultsPage()),
                          routes: [
                            GoRoute(
                              path: ':resultId',
                              redirect: (context, state) {
                                final queryId = state.pathParameters['queryId'];
                                final runId = state.pathParameters['runId'];
                                final resultId =
                                    state.pathParameters['resultId'];
                                return '/queries/$queryId/runs/$runId/results/$resultId/timeline';
                              },
                            ),
                            GoRoute(
                              path: ':resultId/timeline',
                              builder: (context, state) =>
                                  MultiProvider(providers: [
                                Provider<RunId>(
                                    create: (_) =>
                                        RunId.fromState(state, 'runId')),
                                Provider<QueryId>(
                                    create: (_) => QueryId.fromState(state)),
                                Provider<ResultId>(
                                    create: (_) => ResultId.fromState(state))
                              ], child: ResultTimelinePage()),
                            )
                          ])
                    ])
              ]),
          GoRoute(
            path: '/compare/:baseId/with/:currentId',
            builder: (context, state) => MultiProvider(providers: [
              Provider<BaseRunId>(create: (_) => BaseRunId(state)),
              Provider<CurrentRunId>(create: (_) => CurrentRunId(state))
            ], child: const ComparisonPageProvider()),
          ),
          GoRoute(
              path: '/tests/comparison',
              builder: (context, state) => const ComparisonTestPage()),
          GoRoute(
              path: '/tests/run/comparison',
              builder: (context, state) => const RunComparisonTestPage()),
          GoRoute(
            path: '/tests/result',
            builder: (context, state) => ResultTestPage(),
          ),
        ],
      );
}
