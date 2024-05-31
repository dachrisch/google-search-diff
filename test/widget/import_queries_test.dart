import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store_export.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/search/search_service_provider.dart';
import 'package:google_search_diff/widget/queries/queries_page.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';
import '../util/localstore_helper.dart';
import '../util/test_provider.dart';
import 'widget_tester_extension.dart';

void main() {
  Mocked mocked = Mocked();
  setUp(() async {
    cleanupBefore(['.runs', '.queries']);
    for (var qr in List.from(mocked.queriesStore.queryRuns)) {
      await mocked.queriesStore.removeQueryRuns(qr);
    }
    var query = Query('Test query');
    var queryRunsModel = QueryRuns.fromRun(
        Run(query,
            [Result(title: 'Test', source: 'T', link: 'http://example.com')]),
        mocked.dbRunsService);
    await mocked.queriesStore.addQueryRuns(queryRunsModel);
  });

  setUpAll(() {
    getIt.registerSingleton(mocked.queriesStoreExportService);
    getIt.registerSingleton(mocked.filePickerService);
  });

  testWidgets('Import queries (will retain existing)',
      (WidgetTester tester) async {
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

    await tester.tapButtonByKey('open-menu-button');
    await tester.tapButtonByKey('import-queries-button');
    await tester.pumpAndSettle();
    expect(mocked.queriesStore.items, 3);
    expect(find.byType(QueryRunsCard), findsNWidgets(3));
  });

  testWidgets('Import queries (will overwrite same query)',
      (WidgetTester tester) async {
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider.value(value: mocked.queriesStore),
        ChangeNotifierProvider<SearchServiceProvider>.value(
            value: Mocked().searchServiceProvider),
      ],
      scaffoldUnderTest: const QueriesPage(),
    ));

    expect(mocked.queriesStore.items, 1);
    expect(mocked.dbRunsService.fetchAll().length, 1);

    final Uri basedir = (goldenFileComparator as LocalFileComparator).basedir;
    var export = QueriesStoreExport.fromJson(jsonDecode(
        File('${basedir.toFilePath()}/test-file.json').readAsStringSync()));
    await mocked.queriesStore.addQueryRuns(QueryRuns.fromTransientRuns(
        export.queries.first,
        export.runs.where((r) => r.query == export.queries.first),
        mocked.dbRunsService));

    expect(mocked.queriesStore.items, 2);
    expect(mocked.dbRunsService.fetchAll().length, 2);

    await tester.tapButtonByKey('open-menu-button');
    await tester.tapButtonByKey('import-queries-button');
    await tester.pumpAndSettle();
    expect(mocked.queriesStore.items, 3);
    expect(mocked.dbRunsService.fetchAll().length, 3);
    expect(find.byType(QueryRunsCard), findsNWidgets(3));
  });
}
