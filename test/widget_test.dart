// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:google_search_diff/view/search_result_list_tile.dart';

void main() {
  testWidgets('Test search produces 3 results', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));

    expect(find.byType(SearchResultListTile), findsNWidgets(0));

    await tester.performSearch('Test Search');

    expect(find.byType(SearchResultListTile), findsNWidgets(3));
  });

  testWidgets('Saving and deleting a result', (tester) async {
    cleanupBefore();

    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));

    expectBadgeVisible(false);

    await tester.performSearch('Test Search');
    expect(find.byType(SearchResultListTile), findsNWidgets(3));

    expectBadgeVisible(false);

    await tester.tapButton('save-search-button');
    expectBadgeLabel('1');
    await tester.tapButton('delete-search-button');
    expectBadgeVisible(false);
  });

  testWidgets('Save two searches, retrieve one and delete it', (tester) async {
    cleanupBefore();
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));
    await tester.performSearch('Test Search 1');
    expect(find.byType(SearchResultListTile), findsNWidgets(3));
    expect(find.byType(SearchResultListTile).evaluate().every((element) =>(element.widget as SearchResultListTile).searchResult.status == SearchResultsStatus.added),true);
    await tester.tapButton('save-search-button');
    expectBadgeLabel('1');
    await tester.performSearch('Test Search 2');
    await tester.pumpAndSettle();
    expect(find.byType(SearchResultListTile), findsNWidgets(3));
    expect(find.byType(SearchResultListTile).evaluate().any((element) =>(element.widget as SearchResultListTile).searchResult.status == SearchResultsStatus.existing),true);
    expect(find.byType(SearchResultListTile).evaluate().any((element) =>(element.widget as SearchResultListTile).searchResult.status == SearchResultsStatus.added),true);
    // expect(find.byType(SearchResultListTile).evaluate().any((element) =>(element.widget as SearchResultListTile).searchResult.status == SearchResultsStatus.removed),true);
    await tester.tapButton('save-search-button');
    expectBadgeLabel('2');

    await tester.tapButton('saved-searches-badge');
    expect(find.byType(PopupMenuItem<String>), findsNWidgets(2));
    await tester.tap(find.byType(PopupMenuItem<String>).first);
    await tester.pumpAndSettle();
    expect(find.byType(SearchResultListTile), findsNWidgets(3));
    expect(find.byType(SearchResultListTile).evaluate().every((element) =>(element.widget as SearchResultListTile).searchResult.status == SearchResultsStatus.existing),true);
  });
}

extension ButtonTap on WidgetTester {
  Future<int> tapButton(String key) async {
    await tap(find.byKey(Key(key)));
    return pumpAndSettle(); // https://stackoverflow.com/questions/49542389/flutter-get-a-popupmenubuttons-popupmenuitem-text-in-unit-tests
  }

  Future<int> performSearch(String query) async {
    expect(find.byKey(const Key('search-query-field')), findsOneWidget);
    await enterText(find.byKey(const Key('search-query-field')), query);
    await tap(find.byKey(const Key('do-search-button')));
    return pumpAndSettle();
  }
}

void cleanupBefore() {
  var directory = Directory('.search');
  if (directory.existsSync()) directory.deleteSync(recursive: true);
}

void expectBadgeVisible(bool isVisible) {
  expect(
      ((find.byKey(const Key('saved-searches-badge')).evaluate().first
                  as StatelessElement)
              .widget as Badge)
          .isLabelVisible,
      isVisible);
}

void expectBadgeLabel(String text) {
  expectBadgeVisible(true);
  expect(
      (((find.byKey(const Key('saved-searches-badge')).evaluate().first
                      as StatelessElement)
                  .widget as Badge)
              .label as Text)
          .data,
      text);
}
