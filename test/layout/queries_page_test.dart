import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';

void main() {
  testWidgets('Has info when no queries', (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var mocked = await tester.pumpMockedApp(Mocked());
    await tester.pumpAndSettle();

    expect(mocked.queriesStore.items, 0);
    var centerText = find.widgetWithText(Center, 'No queries saved.');
    expect(centerText, findsOneWidget);
    var image = find.descendant(of: centerText, matching: find.byType(Image));
    expect(image, findsOneWidget);
    expect(find.descendant(of: centerText, matching: find.byType(InkWell)),
        findsOneWidget);
  });
}
