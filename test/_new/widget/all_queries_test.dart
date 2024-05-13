import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/page/queries_page.dart';
import 'package:google_search_diff/service/search_service.dart';
import 'package:google_search_diff/widget/card/query_runs_card.dart';
import 'package:provider/provider.dart';

import '../util/localstore_helper.dart';
import '../util/service_mocks.dart';
import '../util/test_provider.dart';
import 'search_bar_test.dart';
import 'widget_tester_extension.dart';

void main() {
  setUp(() => cleanupBefore(['.runs', '.queries']));

  testWidgets('Adds a single query and removes it',
      (WidgetTester tester) async {
    var searchQueriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: MockDbRunsService());

    var query = Query('Test query');
    var queryRunsModel = QueryRuns.fromRun(
        Run(query,
            [Result(title: 'Test', source: 'T', link: 'http://example.com')]),
        MockDbRunsService());
    searchQueriesStore.addQueryRuns(queryRunsModel);
    var testSearchService = TestSearchService();
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider.value(value: searchQueriesStore),
        Provider<SearchService>.value(
          value: testSearchService,
        ),
      ],
      scaffoldUnderTest: const QueriesPage(),
    ));

    expect(searchQueriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsNWidgets(1));

    expect(find.widgetWithText(Row, '1'), findsOneWidget);
    await tester
        .tapButtonByKey('refresh-query-results-outside-button-${query.id.id}');
    expect(find.widgetWithText(Row, '2'), findsOneWidget);

    await tester.tapButtonByKey(
        'delete-search-query-${searchQueriesStore.at(0).query.id}');
    expect(searchQueriesStore.items, 0);
    expect(find.byType(QueryRunsCard), findsNWidgets(0));
  });
}
