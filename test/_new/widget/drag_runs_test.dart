import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/page/query_runs.dart';
import 'package:google_search_diff/routes/query_id.dart';
import 'package:google_search_diff/service/search_service.dart';
import 'package:google_search_diff/widget/card/run_card.dart';
import 'package:google_search_diff/widget/comparison/run_feedback_card.dart';
import 'package:google_search_diff/widget/comparison/run_target.dart';
import 'package:provider/provider.dart';

import '../util/localstore_helper.dart';
import '../util/service_mocks.dart';
import '../util/test_provider.dart';
import 'widget_tester_extension.dart';

void main() {
  setUp(() => cleanupBefore(['.runs', '.queries']));

  testWidgets('Drags a run to the target', (WidgetTester tester) async {
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
          Provider<SearchService>.value(value: LoremIpsumSearchService())
        ],
        scaffoldUnderTest: const QueryRunsPage(),
      ),
    ));

    expect(find.byType(RunCard), findsNWidgets(2));

    TestGesture baseGesture =
        await tester.grabCard<RunCard>((found) => found.first);
    // expect feedback
    expect(find.byType(RunFeedbackCard), findsOneWidget);
    var baseDropTarget =
        await tester.moveCardToTarget<RunDragTarget, EmptyTarget>(
            baseGesture, (found) => found.first);
    // expect dropped
    expect(
        find.descendant(
            of: baseDropTarget, matching: find.byType(TargetWithRun)),
        findsOneWidget);

    TestGesture currentGesture =
        await tester.grabCard<RunCard>((found) => found.last);
    // expect feedback
    expect(find.byType(RunFeedbackCard), findsOneWidget);
    var currentDropTarget =
        await tester.moveCardToTarget<RunDragTarget, EmptyTarget>(
            currentGesture, (found) => found.last);
    // expect dropped
    expect(
        find.descendant(
            of: currentDropTarget, matching: find.byType(TargetWithRun)),
        findsOneWidget);
  });
}
