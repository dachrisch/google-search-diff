import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:google_search_diff/view/search_result_list_tile.dart';

import 'util/expect_extensions.dart';
import 'util/localstore_helper.dart';
import 'util/widget_tester_extension.dart';

void main() {
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
    expect(
        find.byType(SearchResultListTile).evaluate().every((element) =>
            (element.widget as SearchResultListTile).searchResult.status ==
            SearchResultsStatus.added),
        true);
    await tester.tapButton('save-search-button');
    expectBadgeLabel('1');
    await tester.performSearch('Test Search 2');
    var resultTiles = find.byType(SearchResultListTile, skipOffstage: false);
    expect(resultTiles, findsNWidgets(4));
    expect(
        resultTiles.evaluate().any((element) =>
            (element.widget as SearchResultListTile).searchResult.status ==
            SearchResultsStatus.existing),
        true);
    expect(
        resultTiles.evaluate().any((element) =>
            (element.widget as SearchResultListTile).searchResult.status ==
            SearchResultsStatus.added),
        true);
    expect(
        resultTiles.evaluate().any((element) =>
            (element.widget as SearchResultListTile).searchResult.status ==
            SearchResultsStatus.removed),
        true);

    await tester.tapButton('save-search-button');
    expectBadgeLabel('2');

    await tester.tapButton('saved-searches-badge');
    expect(find.byType(MenuItemButton), findsNWidgets(2));
    await tester.tap(find.byType(MenuItemButton).first);
    await tester.pumpAndSettle();
    expect(find.byType(SearchResultListTile), findsNWidgets(3));
    expect(
        find.byType(SearchResultListTile).evaluate().every((element) =>
            (element.widget as SearchResultListTile).searchResult.status ==
            SearchResultsStatus.existing),
        true);

    await tester.tapButton('delete-search-button');
    expectBadgeLabel('1');
    expect(find.byType(SearchResultListTile), findsNothing);
  });

  testWidgets('Retrieve stored query', (tester) async {
    cleanupBefore();

    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));

    expectBadgeVisible(false);

    await tester.performSearch('Test Search Stored');
    expect(find.byType(SearchResultListTile), findsNWidgets(3));

    await tester.tapButton('save-search-button');
    expectBadgeLabel('1');

    await tester.performSearch('Test Search Volatile');
    expectSearchField('Test Search Volatile');
    await tester.tapButton('saved-searches-badge');
    expect(find.byType(MenuItemButton), findsNWidgets(1));
    await tester.tap(find.byType(MenuItemButton).first);
    await tester.pumpAndSettle();
    expectSearchField('Test Search Stored');
  });

  testWidgets('Removing an item from the search', (tester) async {
    cleanupBefore();

    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));

    expectBadgeVisible(false);
    await tester.performSearch('Test Search Stored');
    expect(find.byType(SearchResultListTile), findsNWidgets(3));

    expect(find.widgetWithText(TextButton, 'Remove').first, findsOne);
    await tester.tap(find.widgetWithText(TextButton, 'Remove').first);
    await tester.pumpAndSettle();
    
    expect(find.byType(SearchResultListTile), findsNWidgets(2));

  });
}
