import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/model/run_id.dart';
import 'package:google_search_diff/routes/query_id.dart';
import 'package:google_search_diff/widget/result/result_card.dart';
import 'package:google_search_diff/widget/result/results_page.dart';
import 'package:provider/provider.dart';

import '../util/service_mocks.dart';
import '../util/test_provider.dart';
import 'widget_tester_extension.dart';

void main() {
  testWidgets('Filters results by source', (tester) async {
    var queriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: MockDbRunsService());

    var query = Query('Test query');
    var run = Run(query, [
      Result(title: 'Test', source: 'T', link: 'http://example.com'),
      Result(title: 'Test', source: 'B', link: 'http://example.com'),
      Result(title: 'Test', source: 'Y', link: 'http://example.com')
    ]);
    var queryRunsModel = QueryRuns.fromRun(run, MockDbRunsService());
    queriesStore.addQueryRuns(queryRunsModel);
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider.value(value: queriesStore),
        Provider<QueryId>.value(
          value: query.id,
        ),
        Provider<RunId>.value(value: run.id)
      ],
      scaffoldUnderTest: const ResultsPage(),
    ));

    expect(find.byType(ResultCard), findsNWidgets(3));
    await tester.tapButtonByKey('open-filter-button');
    expect(find.byType(CheckboxListTile), findsNWidgets(3));
    var checkboxFinder = find.byType(Checkbox);
    var checkbox = tester.firstWidget<Checkbox>(checkboxFinder);
    expect(checkbox.value, true);
    await tester.tap(checkboxFinder.first);
    await tester.tap(find.byWidgetPredicate((widget) =>
        widget is Icon && widget.icon == Icons.check_circle_outline));
    await tester.pumpAndSettle();
    expect(find.byType(ResultCard), findsNWidgets(2));
  });
}
