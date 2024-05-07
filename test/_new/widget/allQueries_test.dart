import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/page/queries_scaffold.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/query_card.dart';
import 'package:provider/provider.dart';

import '../util/localstore_helper.dart';
import '../util/testProvider.dart';
import 'search_bar_test.dart';
import 'widget_tester_extension.dart';

void main() {
  setUp(() => cleanupBefore(['.runs', '.queries']));

  testWidgets('Adds a single query and removes it',
      (WidgetTester tester) async {
    var searchQueriesStore = QueriesStoreModel();
    await searchQueriesStore.initFuture;
    var query = Query('Test query');
    var queryRunsModel = QueryRunsModel(query);
    queryRunsModel.addRun(Results(query,
        [ResultModel(title: 'Test', source: 'T', link: 'http://example.com')]));
    searchQueriesStore.add(queryRunsModel);
    var testSearchService = TestSearchService();
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider.value(value: searchQueriesStore),
        Provider<SearchService>.value(
          value: testSearchService,
        ),
      ],
      scaffoldUnderTest: const QueriesScaffold(),
    ));

    expect(searchQueriesStore.items, 1);
    expect(find.byType(SingleQueryCard), findsNWidgets(1));

    expect(find.widgetWithText(Row, '1'), findsOneWidget);
    await tester.tapButtonByKey('refresh-query-results-outside-button-${query.queryId.id}');
    expect(find.widgetWithText(Row, '2'), findsOneWidget);

    await tester.tapButtonByKey(
        'delete-search-query-${searchQueriesStore.at(0).query.queryId}');
    expect(searchQueriesStore.items, 0);
    expect(find.byType(SingleQueryCard), findsNWidgets(0));
  });

}
