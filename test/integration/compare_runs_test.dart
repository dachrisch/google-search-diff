import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/comparison/comparison_page.dart';
import 'package:google_search_diff/widget/results/result_card.dart';
import 'package:google_search_diff/widget/run/run_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';
import '../widget/widget_tester_extension.dart';

void main() {
  testWidgets('Compare two runs', (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var mocked = await tester.pumpMockedApp(Mocked());
    var query = Query('Saved query 1');
    await mocked.queriesStore.addQueryRuns(QueryRuns.fromRun(
        Run(query, [Result(title: 'result 1')]), mocked.dbRunsService));
    await mocked.queriesStore.queryRuns[0]
        .addRun(Run(query, [Result(title: 'result 2')]));
    await tester.pumpAndSettle();
    // goto runs
    expect(mocked.queriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsOne);
    await tester.tap(find.byType(QueryRunsCard));
    await tester.pumpAndSettle();
    expect(find.byType(RunCard), findsNWidgets(2));

    // drag base
    await tester.dragTo<RunCard>(DropTarget.first, DropTargetExpect.bothEmpty);
    await tester.dragTo<RunCard>(DropTarget.second, DropTargetExpect.oneEmpty);

    await tester.tapButtonByKey('compare-runs-button');
    await tester.pumpAndSettle();

    expect(find.byType(ComparisonPage), findsOneWidget);
    expect(find.byType(ResultCard), findsNWidgets(2));
  });
}
