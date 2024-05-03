import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/page/queries_scaffold.dart';
import 'package:google_search_diff/_new/widget/query_card.dart';
import 'package:provider/provider.dart';

import 'util/testProvider.dart';
import 'widget_tester_extension.dart';

void main() {
  testWidgets('Adds a single query and removes it',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var searchQueriesStore = QueriesStoreModel();
    searchQueriesStore.add(QueryModel(Query('Test query')));
    await tester.pumpWidget(ScaffoldValueProviderTestApp<QueriesStoreModel>(
      providedValue: searchQueriesStore,
      scaffoldUnderTest: const QueriesScaffold(),
    ));

    expect(searchQueriesStore.items, 1);
    expect(find.byType(SingleQueryCard), findsNWidgets(1));

    expect(find.widgetWithText(Column, 'Results: 0'), findsOneWidget);
    await tester.tapButtonByKey('refresh-query-results-outside-button');
    expect(find.widgetWithText(Column, 'Results: 1'), findsOneWidget);

    await tester.tapButtonByKey(
        'delete-search-query-${searchQueriesStore.at(0).queryId}');
    expect(searchQueriesStore.items, 0);
    expect(find.byType(SingleQueryCard), findsNWidgets(0));
  });
}
