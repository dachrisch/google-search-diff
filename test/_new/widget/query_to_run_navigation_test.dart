import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/router_app.dart';
import 'package:google_search_diff/service/search_service.dart';
import 'package:google_search_diff/theme.dart';
import 'package:google_search_diff/widget/card/query_runs_card.dart';
import 'package:google_search_diff/widget/card/run_card.dart';
import 'package:provider/provider.dart';

import '../util/service_mocks.dart';

void main() {
  testWidgets('Transitions from Query to Run View',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var queriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: MockDbRunsService());

    await queriesStore.addQueryRuns(QueryRuns.fromRun(
        Run(Query('Saved query 1'), [Result(title: 'result 1')]),
        MockDbRunsService()));
    var theme = MaterialTheme(ThemeData.light().primaryTextTheme);

    await tester.pumpWidget(RouterApp(
      theme: theme,
      queriesStore: queriesStore,
      searchService: LoremIpsumSearchService(),
      historyService: MockHistoryService(),
    ));

    expect(queriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsOne);
    await tester.tap(find.byType(QueryRunsCard));
    await tester.pumpAndSettle();

    expect(find.byType(RunCard), findsOne);
  });
}
