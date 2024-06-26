import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_page.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';

void main() {
  testWidgets('Transitions from Query to Run View',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var mocked = await tester.pumpMockedApp(Mocked());
    var query = Query('Saved query 1');
    mocked.queriesStore.addQueryRuns(QueryRuns.fromRun(
        Run(query, [Result(title: 'result 1')]), mocked.dbRunsService));
    await tester.pumpAndSettle();

    expect(mocked.queriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsOne);
    await tester.tap(find.byType(QueryRunsCard));
    await tester.pumpAndSettle();

    expect(find.byType(QueryRunsPage), findsOne);
  });
}
