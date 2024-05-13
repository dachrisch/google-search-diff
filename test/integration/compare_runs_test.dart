import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/router_app.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:google_search_diff/theme.dart';
import 'package:google_search_diff/widget/comparison/comparison_page.dart';
import 'package:google_search_diff/widget/result/result_card.dart';
import 'package:google_search_diff/widget/run/run_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../util/service_mocks.dart';
import '../widget/widget_tester_extension.dart';

void main() {
  testWidgets('Compare two runs', (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var mockDbRunsService = MockDbRunsService();
    var queriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: mockDbRunsService);
    getIt.registerSingleton<DbRunsService>(mockDbRunsService);

    await initializeDateFormatting();

    var query = Query('Saved query 1');
    await queriesStore.addQueryRuns(QueryRuns.fromRun(
        Run(query, [Result(title: 'result 1')]), mockDbRunsService));
    await queriesStore.queryRuns[0]
        .addRun(Run(query, [Result(title: 'result 2')]));

    var theme = MaterialTheme(ThemeData.light().primaryTextTheme);

    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(0.5)),
      child: RouterApp(
        theme: theme,
        queriesStore: queriesStore,
        searchService: LoremIpsumSearchService(),
        historyService: MockHistoryService(),
      ),
    ));

    // goto runs
    expect(queriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsOne);
    await tester.tap(find.byType(QueryRunsCard));
    await tester.pumpAndSettle();
    expect(find.byType(RunCard), findsNWidgets(2));

    // drag base
    await tester.dragTo<RunCard>(DropTarget.first, DropTargetExpect.bothEmpty);
    await tester.dragTo<RunCard>(DropTarget.second, DropTargetExpect.oneEmpty);

    await tester.tapButtonByKey('compare-runs-button');
    await tester.pumpAndSettle();

    expect(find.byType(ComparisonPage), findsOneWidget);
    expect(find.byType(ResultCard), findsNWidgets(2));
  });
}
