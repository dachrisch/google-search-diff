import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/search/search_service_provider.dart';
import 'package:google_search_diff/service/history_service.dart';
import 'package:google_search_diff/service/queries_store_export_service.dart';
import 'package:google_search_diff/widget/queries/queries_page.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';
import '../util/localstore_helper.dart';
import '../util/service_mocks.dart';
import '../util/test_provider.dart';
import 'widget_tester_extension.dart';

void main() {
  final Mocked mocked = Mocked();
  setUp(() {
    cleanupBefore(['.runs', '.queries']);
    var query = Query('Test query');
    var queryRunsModel = QueryRuns.fromRun(
        Run(query,
            [Result(title: 'Test', source: 'T', link: 'http://example.com')]),
        MockDbRunsService());
    mocked.queriesStore.addQueryRuns(queryRunsModel);
    Provider.debugCheckInvalidValueType = null;
  });

  setUpAll(() {
    getIt.registerSingleton(
        QueriesStoreExportService(queriesStore: mocked.queriesStore));
  });

  testWidgets('Adds a single query and removes it',
      (WidgetTester tester) async {
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider<QueriesStore>.value(value: mocked.queriesStore),
        ChangeNotifierProvider<HistoryService>.value(
            value: mocked.historyService),
        ChangeNotifierProvider<SearchServiceProvider>.value(
            value: mocked.searchServiceProvider),
      ],
      scaffoldUnderTest: const QueriesPage(),
    ));

    expect(mocked.queriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsNWidgets(1));

    expect(find.widgetWithText(Row, '1'), findsOneWidget);
    await tester.tapButtonByKey(
        'refresh-query-results-outside-button-${mocked.queriesStore.queryRuns.single.query.id.id}');
    expect(find.widgetWithText(Row, '2'), findsOneWidget);

    await tester.tapButtonByKey(
        'delete-search-query-${mocked.queriesStore.at(0).query.id}');
    expect(mocked.queriesStore.items, 0);
    expect(find.byType(QueryRunsCard), findsNWidgets(0));
  });

  testWidgets('Undo query remove', (WidgetTester tester) async {
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider.value(value: mocked.queriesStore),
        ChangeNotifierProvider<SearchServiceProvider>.value(
            value: Mocked().searchServiceProvider),
      ],
      scaffoldUnderTest: const QueriesPage(),
    ));

    expect(mocked.queriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsNWidgets(1));
    expect(find.widgetWithText(Row, '1'), findsOneWidget);

    await tester.tapButtonByKey(
        'delete-search-query-${mocked.queriesStore.at(0).query.id}');
    expect(mocked.queriesStore.items, 0);
    expect(find.byType(QueryRunsCard), findsNWidgets(0));

    await tester.tapButtonByKey('snackbar-action-button');
    await tester.pumpAndSettle();
    expect(mocked.queriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsNWidgets(1));
    expect(find.widgetWithText(Row, '1'), findsOneWidget);
  });
}
