import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:google_search_diff/view/search_result_list_tile.dart';

import 'util/expect_extensions.dart';
import 'util/widget_tester_extension.dart';

void main() {
  testWidgets('Test search produces 3 results', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));

    expect(find.byType(SearchResultListTile), findsNWidgets(0));

    await tester.performSearch('Test Search');

    expect(find.byType(SearchResultListTile), findsNWidgets(3));
  });

  testWidgets('Search on Enter key', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));

    expect(find.byType(SearchResultListTile), findsNWidgets(0));

    expect(find.byKey(const Key('search-query-field')), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('search-query-field')), 'Test Query');
    expectSearchField('Test Query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.byType(SearchResultListTile), findsNWidgets(3));
  });

  testWidgets('Escape clears search', (tester) async {
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));
    await tester.enterText(
        find.byKey(const Key('search-query-field')), 'Test Query');
    expectSearchField('Test Query');
    await simulateKeyDownEvent(LogicalKeyboardKey.escape);
    expectSearchField('');
  });

  testWidgets('Display alert when search produces an error', (tester) async {
    var performingSearchError = PerformingSearchError('Request took too long');
    await tester.pumpWidget(MyApp(
        retriever: FailingStaticRetriever(
            performingSearchError)));
    expect(find.byType(AlertDialog), findsNothing);
    await tester.enterText(
        find.byKey(const Key('search-query-field')), 'Test Query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOne);
    expect((find.byType(AlertDialog).evaluate().first.widget as AlertDialog).title.toString(), const Text('Error while searching').toString());
    expect((find.byType(AlertDialog).evaluate().first.widget as AlertDialog).content.toString(), Text('PerformingSearchError: ${performingSearchError.message}').toString());

  });
}

class FailingStaticRetriever extends StaticRetriever {
  final PerformingSearchError performingSearchError;
  FailingStaticRetriever(this.performingSearchError);

  @override
  Future<List<SearchResult>> query(String query) {
    return super.query(query).then((value) => throw performingSearchError);
  }
}
