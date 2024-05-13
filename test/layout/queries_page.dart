import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/routes/router_app.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:google_search_diff/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../util/service_mocks.dart';

void main() {
  testWidgets('Has info when no queries', (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var mockDbRunsService = MockDbRunsService();
    var queriesStore = QueriesStore(
        dbQueryService: MockDbQueriesService(),
        dbRunsService: mockDbRunsService);
    getIt.registerSingleton<DbRunsService>(mockDbRunsService);

    await initializeDateFormatting();

    var theme = MaterialTheme(ThemeData.light().primaryTextTheme);

    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(0.5)),
      child: RouterApp(
        theme: theme,
        queriesStore: queriesStore,
        searchService: LoremIpsumSearchService(),
        historyService: MockHistoryService(),
      ),
    ));

    // goto runs
    expect(queriesStore.items, 0);
    var centerText = find.widgetWithText(Center, 'No queries saved.');
    expect(centerText, findsOneWidget);
    var image = find.descendant(of: centerText, matching: find.byType(Image));
    expect(image, findsOneWidget);
    expect(find.descendant(of: centerText, matching: find.byType(InkWell)),
        findsOneWidget);
  });
}
