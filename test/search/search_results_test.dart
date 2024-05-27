import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/router_app.dart';
import 'package:google_search_diff/theme.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';
import '../widget/widget_tester_extension.dart';

void main() {
  testWidgets('Search results appear in results list',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var searchQueriesStore = QueriesStore(
        dbQueryService: Mocked().dbQueriesService,
        dbRunsService: Mocked().dbRunsService);

    var theme = MaterialTheme(ThemeData.light().primaryTextTheme);

    getIt.registerFactoryParam<QueryRuns, Run, Null>(
        (param1, param2) => QueryRuns.fromRun(param1, Mocked().dbRunsService));

    await tester.pumpWidget(RouterApp(
      theme: theme,
      queriesStore: searchQueriesStore,
      searchServiceProvider: Mocked().searchServiceProvider,
      historyService: Mocked().historyService,
    ));

    expect(find.byType(QueryRunsCard), findsNothing);
    expect(searchQueriesStore.items, 0);
    await tester.tapButtonByKey('show-searchbar-button');
    expect(find.widgetWithText(Container, 'No recent searches'), findsOne);
    var searchField = find.byWidgetPredicate((widget) =>
        widget is TextField &&
        widget.decoration?.hintText == 'Create search...');
    expect(searchField, findsOne);
    await tester.enterText(searchField, 'Test query 1');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tapButtonByKey('add-search-query-button');
    await tester.pumpAndSettle();
    expect(searchQueriesStore.items, 1);
    expect(searchQueriesStore.queryRuns.first.runs.length, 1);
    expect(find.byType(QueryRunsCard), findsOne);
  });
}
