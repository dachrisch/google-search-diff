import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:google_search_diff/widget/run/run_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_page.dart';
import 'package:provider/provider.dart';

import '../search/search_bar_test.dart';
import '../util/service_mocks.dart';
import '../util/test_provider.dart';
import 'widget_tester_extension.dart';

void main() {
  testWidgets('Refresh adds a new result and then deletes it',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var searchQuery = QueryRuns.fromTransientRuns(
        Query('Test query'), [], MockDbRunsService());
    var testSearchService = TestSearchService();
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        Provider.value(value: ComparisonViewModel()),
        ChangeNotifierProvider.value(value: searchQuery),
        Provider<SearchService>.value(
          value: testSearchService,
        ),
      ],
      scaffoldUnderTest: const QueryRunsPageScaffold(),
    ));

    expect(find.byType(RunCard), findsNWidgets(0));
    expect(searchQuery.items, 0);

    await tester.dragFrom(const Offset(50, 100), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(searchQuery.items, 1);
    expect(find.byType(RunCard), findsNWidgets(1));

    await tester
        .tapButtonByKey('delete-query-results-${searchQuery.runAt(0).id}');
    expect(searchQuery.items, 0);
    expect(find.byType(RunCard), findsNWidgets(0));
  });
}
