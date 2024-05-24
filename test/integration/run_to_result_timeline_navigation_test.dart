import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/results/result_card.dart';
import 'package:google_search_diff/widget/results/timeline/result_timeline_page.dart';
import 'package:google_search_diff/widget/results/timeline/result_timeline_tile.dart';
import 'package:google_search_diff/widget/run/run_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';

import '../service/widget_tester_extension.dart';

class TestImageProvider extends ImageProvider {
  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('Transitions Result View to Result Timeline',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    var mocked = await tester.pumpMockedApp(Mocked());
    var query = Query('Saved query 1');
    mocked.queriesStore.addQueryRuns(QueryRuns.fromRun(
        Run(query, [Result(title: 'result 1')]), mocked.dbRunsService));
    await tester.pumpAndSettle();

    expect(mocked.queriesStore.items, 1);
    expect(find.byType(QueryRunsCard), findsOne);
    await tester.tap(find.byType(QueryRunsCard));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RunCard));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ResultCard));
    await tester.pumpAndSettle();
    expect(find.byType(ResultTimelinePage), findsOneWidget);
    expect(find.byType(ResultTimelineTile), findsOneWidget);
  });
}
