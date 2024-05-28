import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/widget/enter/enter_page.dart';
import 'package:google_search_diff/widget/queries/queries_page.dart';

import '../service/widget_tester_extension.dart';
import '../widget/widget_tester_extension.dart';

void main() {
  testWidgets(
      'Checks that touch targets with a tap or long press action are labeled.',
      (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    var mocked = await tester.pumpMockedApp(Mocked(), goto: null);

    expect(find.byType(EnterPage), findsOneWidget);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    await tester.tapButtonByKey('try-it-button');
    await tester.pumpAndSettle();
    expect(find.byType(QueriesPage), findsOneWidget);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    await tester.tapButtonByKey('show-searchbar-button');
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });
}
