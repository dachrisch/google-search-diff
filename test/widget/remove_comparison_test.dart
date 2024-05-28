import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/query_id.dart';
import 'package:google_search_diff/search/search_service_provider.dart';
import 'package:google_search_diff/widget/comparison/run_target.dart';
import 'package:google_search_diff/widget/run/run_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_page.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';
import '../util/localstore_helper.dart';
import '../util/service_mocks.dart';
import '../util/test_provider.dart';
import 'widget_tester_extension.dart';

void main() {
  setUp(() => cleanupBefore(['.runs', '.queries']));

  testWidgets('Adds, removes and re-adds a run to comparison',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var queriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: MockDbRunsService());

    QueryId queryId = QueryId.withUuid();
    var query = Query('Saved query 1', id: queryId);
    await queriesStore.addQueryRuns(QueryRuns.fromRun(
        Run(query, [Result(title: 'result 1')]), MockDbRunsService()));
    await queriesStore.queryRuns[0]
        .addRun(Run(query, [Result(title: 'result 2')]));

    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(0.5)),
      child: ScaffoldMultiProviderTestApp(
        providers: [
          Provider<QueryId>.value(value: queryId),
          ChangeNotifierProvider<QueriesStore>.value(value: queriesStore),
          ChangeNotifierProvider<SearchServiceProvider>.value(
              value: Mocked().searchServiceProvider)
        ],
        scaffoldUnderTest: const QueryRunsPage(),
      ),
    ));

    expect(find.byType(RunCard), findsNWidgets(2));

    var dropTarget = await tester.dragTo<RunCard>(
        DropTarget.first, DropTargetExpect.bothEmpty);

    // remove item
    await tester
        .tap(find.descendant(of: dropTarget, matching: find.byType(InkWell)));
    await tester.pumpAndSettle();
    expect(find.byType(EmptyTarget), findsNWidgets(2));
  });
}
