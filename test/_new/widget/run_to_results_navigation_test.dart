import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/routes/router_app.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:google_search_diff/_new/widget/card/query_card.dart';
import 'package:google_search_diff/_new/widget/card/result_card.dart';
import 'package:google_search_diff/_new/widget/card/run_card.dart';
import 'package:provider/provider.dart';

import '../util/service_mocks.dart';

class TestImageProvider extends ImageProvider {
  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    throw UnimplementedError();
  }

}




void main() {
  testWidgets('Transitions from Query to Result View',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    Provider.debugCheckInvalidValueType = null;
    var queriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: MockDbRunsService());

    await queriesStore.add(QueryRuns.fromRun(
        Run(Query('Saved query 1'), [Result(title: 'result 1')]),
        MockDbRunsService()));
    var theme = MaterialTheme(ThemeData.light().primaryTextTheme);

    final PlatformAssetBundle testBundle = PlatformAssetBundle();
    testBundle.load('assets/logo.png');

    await tester.pumpWidget(DefaultAssetBundle(bundle: testBundle, child: RouterApp(
      theme: theme,
          queriesStore: queriesStore,
          searchService: LoremIpsumSearchService(),
          historyService: MockHistoryService(),
        )));

    expect(queriesStore.items, 1);
    expect(find.byType(QueryCard), findsOne);

    await tester.tap(find.byType(QueryCard));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RunCard));
    await tester.pumpAndSettle();
    expect(find.byType(ResultCard), findsOneWidget);
  });
}
