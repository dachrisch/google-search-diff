import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/enter/enter_page.dart';
import 'package:google_search_diff/widget/queries/queries_page.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';

import '../service/widget_tester_extension.dart';
import '../widget/widget_tester_extension.dart';

void main() {
  testWidgets(
      'Checks that touch targets with a tap or long press action are labeled.',
      (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    var mocked = await tester.pumpMockedApp(Mocked(), goto: null);
    mocked.queriesStore.addQueryRuns(getIt<QueryRuns>(
        param1: Run(Query('test'), [Result(title: 'test title')])));

    expect(find.byType(EnterPage), findsOneWidget);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    await tester.tapButtonByKey('try-it-button');
    await tester.pumpAndSettle();
    expect(find.byType(QueriesPage), findsOneWidget);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    await tester.tapButtonByKey('show-searchbar-button');
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    await tester.tapButtonByKey('back-button');
    await tester.tap(find.byType(QueryRunsCard));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });
}
