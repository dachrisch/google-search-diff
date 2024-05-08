import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/page/runs_page.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/card/run_card.dart';
import 'package:provider/provider.dart';

import '../util/service_mocks.dart';
import '../util/testProvider.dart';
import 'search_bar_test.dart';
import 'widget_tester_extension.dart';

void main() {
  testWidgets('Refresh adds a new result and then deletes it',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var searchQuery =
        QueryRuns(Query('Test query'), dbRunsService: MockDbRunsService());
    var testSearchService = TestSearchService();
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider.value(value: searchQuery),
        Provider<SearchService>.value(
          value: testSearchService,
        ),
      ],
      scaffoldUnderTest: const RunsPageScaffold(),
    ));

    expect(find.byType(RunCard), findsNWidgets(0));
    expect(searchQuery.items, 0);

    await tester.tapButtonByKey('refresh-query-results-button');
    expect(searchQuery.items, 1);
    expect(find.byType(RunCard), findsNWidgets(1));

    await tester
        .tapButtonByKey('delete-query-results-${searchQuery.runAt(0).id}');
    expect(searchQuery.items, 0);
    expect(find.byType(RunCard), findsNWidgets(0));
  });
}
