// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/search_result_list_tile.dart';

void main() {
  testWidgets('Perfoming a simple search with 2 results',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SearchResultListTile), findsNWidgets(0));

    await performSearch(tester, 'Test Search');

    expect(find.byType(SearchResultListTile), findsNWidgets(3));
  });
}

Future<void> performSearch(WidgetTester tester, String query) async {
  expect(find.byKey(const Key('search-query-field')), findsOneWidget);
  await tester.enterText(find.byKey(const Key('search-query-field')), query);
  await tester.tap(find.byKey(const Key('do-search-button')));
  await tester.pump();
}
