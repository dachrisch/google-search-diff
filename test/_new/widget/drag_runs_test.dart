import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/page/query_runs_page.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/card/run_card.dart';
import 'package:google_search_diff/_new/widget/comparison/run_feedback_card.dart';
import 'package:google_search_diff/_new/widget/comparison/run_target.dart';
import 'package:provider/provider.dart';

import '../util/localstore_helper.dart';
import '../util/service_mocks.dart';
import '../util/test_provider.dart';

void main() {
  setUp(() => cleanupBefore(['.runs', '.queries']));

  testWidgets(skip: true, 'Drags a run to the target',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var queriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: MockDbRunsService());

    QueryId queryId = QueryId.withUuid();
    var query = Query('Saved query 1', id: queryId);
    await queriesStore.save(QueryRuns.fromRun(
        Run(query, [Result(title: 'result 1')]), MockDbRunsService()));
    await queriesStore.queryRuns[0]
        .addRun(Run(query, [Result(title: 'result 2')]));

    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        Provider<QueryId>.value(value: queryId),
        ChangeNotifierProvider<QueriesStore>.value(value: queriesStore),
        Provider<SearchService>.value(value: LoremIpsumSearchService())
      ],
      scaffoldUnderTest: const QueryRunsPage(),
    ));

    expect(find.byType(RunCard), findsNWidgets(2));

    // grab the card
    Offset firstResultOffset = tester.getCenter(find.byType(RunCard).first);
    TestGesture baseGesture = await tester.startGesture(firstResultOffset);
    await tester.pumpAndSettle();

    // expect feedback
    expect(find.byType(RunFeedbackCard), findsOneWidget);

    // check target
    var baseDropTarget = find.byType(RunDragTarget).first;
    Offset baseDropTargetOffset = tester.getCenter(baseDropTarget);

    expect(
        find.descendant(of: baseDropTarget, matching: find.byType(EmptyTarget)),
        findsOneWidget);

    // move to drop zone
    await baseGesture.moveTo(baseDropTargetOffset,
        timeStamp: Durations.extralong4);
    await tester.pumpAndSettle();
    await baseGesture.up();
    await tester.pumpAndSettle();

    // expect dropped
    expect(
        find.descendant(
            of: baseDropTarget, matching: find.byType(TargetWithRun)),
        findsOneWidget);
  });
}
