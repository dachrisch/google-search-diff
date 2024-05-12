import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/page/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/card/run_card.dart';
import 'package:google_search_diff/_new/widget/comparison/run_feedback_card.dart';
import 'package:google_search_diff/_new/widget/comparison/run_target.dart';
import 'package:provider/provider.dart';

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
          Provider<SearchService>.value(value: LoremIpsumSearchService())
        ],
        scaffoldUnderTest: const QueryRunsPage(),
      ),
    ));

    expect(find.byType(RunCard), findsNWidgets(2));

    TestGesture baseGesture =
        await tester.grabCard<RunCard>((found) => found.first);
    // expect feedback
    expect(find.byType(EmptyTarget), findsNWidgets(2));
    expect(find.byType(RunFeedbackCard), findsOneWidget);
    var baseDropTarget =
        await tester.moveCardToTarget<RunDragTarget, EmptyTarget>(
            baseGesture, (found) => found.first);
    // expect dropped
    var dropTarget = find.descendant(
        of: baseDropTarget, matching: find.byType(TargetWithRun));
    expect(dropTarget, findsOneWidget);
    expect(find.byType(EmptyTarget), findsNWidgets(1));
    expect(find.byType(TargetWithRun), findsNWidgets(1));

    // remove item
    await tester
        .tap(find.descendant(of: dropTarget, matching: find.byType(InkWell)));
    await tester.pumpAndSettle();
    expect(find.byType(EmptyTarget), findsNWidgets(2));
  });
}
