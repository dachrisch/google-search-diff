import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/service/history_service.dart';
import 'package:google_search_diff/widget/queries/queries_page.dart';
import 'package:provider/provider.dart';

import '../util/service_mocks.dart';
import '../util/test_provider.dart';
import '../widget/widget_tester_extension.dart';

class TestSearchService extends SearchService {
  Query lastSearch = Query('');

  @override
  Future<Run> doSearch(Query query) {
    lastSearch = query;
    return Future.value(Run(query, []));
  }
}

void main() {
  setUp(() {
    Provider.debugCheckInvalidValueType = null;
  });
  testWidgets('Search bar history is added, retrieved and deleted',
      (WidgetTester tester) async {
    var searchQueriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: MockDbRunsService());
    var historyService =
        HistoryService(dbHistoryService: MockDbHistoryService());
    var testSearchService = TestSearchService();
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider<QueriesStore>.value(value: searchQueriesStore),
        ChangeNotifierProvider<HistoryService>.value(value: historyService),
        Provider<SearchService>.value(
          value: testSearchService,
        ),
      ],
      scaffoldUnderTest: const QueriesPage(),
    ));

    await tester.tapButtonByKey('show-searchbar-button');
    expect(find.widgetWithText(Container, 'No recent searches'), findsOne);
    var searchField = find.byWidgetPredicate((widget) =>
        widget is TextField &&
        widget.decoration?.hintText == 'Create search...');
    expect(searchField, findsOne);
    await tester.enterText(searchField, 'Test query 1');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(testSearchService.lastSearch.term, 'Test query 1');
    expect(historyService.queries.length, 1);
    expect(historyService.queries[0].term, 'Test query 1');

    await tester.tapButtonByKey('clear-search-button');
    await tester.enterText(searchField, 'Test query');
    await tester.pumpAndSettle();
    expect(historyService.queries.length, 1);
    expect(find.widgetWithText(Container, 'Recent searches'), findsOne);
    expect(find.widgetWithText(ListTile, 'Test query 1'), findsOne);
    await tester.tapButtonByKey('delete-search-0-button');
    await tester.pumpAndSettle();
    expect(historyService.queries.length, 0);
  });

  testWidgets('Click the appbar will open search', (tester) async {
    var searchQueriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: MockDbRunsService());
    var historyService =
        HistoryService(dbHistoryService: MockDbHistoryService());
    var testSearchService = TestSearchService();
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider<QueriesStore>.value(value: searchQueriesStore),
        ChangeNotifierProvider<HistoryService>.value(value: historyService),
        Provider<SearchService>.value(
          value: testSearchService,
        ),
      ],
      scaffoldUnderTest: const QueriesPage(),
    ));

    await tester.tap(find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'SearchFlux'));
    await tester.pumpAndSettle();
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Semantics &&
            widget.properties.label == 'Create search...'),
        findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) =>
        widget is IconButton &&
        widget.icon is Icon &&
        (widget.icon as Icon).icon == Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(
        find.descendant(of: find.byType(AppBar), matching: find.byType(Image)));
    await tester.pumpAndSettle();
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Semantics &&
            widget.properties.label == 'Create search...'),
        findsOneWidget);
  });
}
