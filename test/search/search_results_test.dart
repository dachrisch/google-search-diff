import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/widget/queries/queries_page.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';

import '../service/widget_tester_extension.dart';
import '../widget/widget_tester_extension.dart';

void main() {
  testWidgets('Search results appear in results list',
      (WidgetTester tester) async {
    var mocked = await tester.pumpMockedApp(Mocked());

    expect(find.byType(QueriesPage), findsOneWidget);
    expect(find.byType(QueryRunsCard), findsNothing);
    expect(mocked.queriesStore.items, 0);
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
    expect(mocked.queriesStore.items, 1);
    expect(mocked.queriesStore.queryRuns.first.runs.length, 1);
    expect(find.byType(QueryRunsCard), findsOne);
  });
}
