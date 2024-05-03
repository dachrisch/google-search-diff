import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/page/queries_scaffold.dart';
import 'package:google_search_diff/_new/service/history_service.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:provider/provider.dart';

import 'util/testProvider.dart';
import 'widget_tester_extension.dart';

class TestSearchService extends SearchService {
  Query lastSearch = Query('');

  @override
  Future<List<ResultModel>> doSearch(Query query) {
    lastSearch = query;
    return Future.value(<ResultModel>[]);
  }
}

void main() {
  setUp(() {
    Provider.debugCheckInvalidValueType = null;
  });
  testWidgets('Search bar history is added, retrieved and deleted',
      (WidgetTester tester) async {
    var searchQueriesStore = QueriesStoreModel();
    var historyService = HistoryService();
    var testSearchService = TestSearchService();
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider<QueriesStoreModel>.value(
            value: searchQueriesStore),
        ChangeNotifierProvider<HistoryService>.value(value: historyService),
        Provider<SearchService>.value(
          value: testSearchService,
        ),
      ],
      scaffoldUnderTest: const QueriesScaffold(),
    ));

    await tester.tapButtonByKey('show-searchbar-button');
    expect(find.widgetWithText(Card, 'No recent searches'), findsOne);
    var searchField = find.byWidgetPredicate((widget) =>
        widget is TextField &&
        widget.decoration?.hintText == 'Create search...');
    expect(searchField, findsOne);
    await tester.enterText(searchField, 'Test query 1');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(testSearchService.lastSearch, Query('Test query 1'));
    expect(historyService.queries.length, 1);
    expect(historyService.queries[0], Query('Test query 1'));

    await tester.tapButtonByKey('clear-search-button');
    await tester.enterText(searchField, 'Test query');
    await tester.pumpAndSettle();
    expect(historyService.queries.length, 1);
    expect(find.widgetWithText(Card, 'Recent searches'), findsOne);
    expect(find.widgetWithText(Card, 'Test query 1'), findsOne);
    await tester.tapButtonByKey('delete-search-0-button');
    await tester.pumpAndSettle();
    expect(historyService.queries.length, 0);

  });
}
