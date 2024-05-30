import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/dependencies.dart';
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
  });

  setUpAll(() {
    getIt.registerSingleton(mocked.queriesStoreExportService);
    getIt.registerSingleton(mocked.filePickerService);
  });

  testWidgets('Import queries', (WidgetTester tester) async {
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
    expect(mocked.queriesStore.items, 2);
    expect(find.byType(QueryRunsCard), findsNWidgets(2));
  });
}
