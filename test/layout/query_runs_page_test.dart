import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/run/run_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_page.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';

void main() {
  testWidgets('Has info to pull down', (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var mocked = await tester.pumpMockedApp(Mocked());
    mocked.queriesStore.addQueryRuns(
        QueryRuns.fromRun(Run(Query('Test1'), []), mocked.dbRunsService));
    await tester.pumpAndSettle();
    // goto runs
    expect(mocked.queriesStore.items, 1);
    await tester.tap(find.byType(QueryRunsCard));
    await tester.pumpAndSettle();
    expect(find.byType(QueryRunsPage), findsOne);
    expect(find.byType(RunCard), findsOneWidget);
  });
}
