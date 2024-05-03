import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/routes/routes.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:google_search_diff/_new/widget/query_card.dart';
import 'package:provider/provider.dart';

import 'widget_tester_extension.dart';

void main() {
  testWidgets('Search results appear in results list',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var searchQueriesStore = QueriesStoreModel();
    var theme = MaterialTheme(ThemeData.light().primaryTextTheme).light();

    await tester.pumpWidget(RouterApp(theme:theme ,queriesStore: searchQueriesStore,));

    expect(find.byType(SingleQueryCard), findsNothing);
    expect(searchQueriesStore.items, 0);
    await tester.tapButtonByKey('show-searchbar-button');
    expect(find.widgetWithText(Card, 'No recent searches'), findsOne);
    var searchField = find.byWidgetPredicate((widget) =>
    widget is TextField && widget.decoration?.hintText == 'Search...');
    expect(searchField, findsOne);
    await tester.enterText(searchField, 'Test query 1');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.tapButtonByKey('save-query-button');
    await tester.pumpAndSettle();
    expect(searchQueriesStore.items, 1);
    expect(find.byType(SingleQueryCard), findsOne);

  });
}
