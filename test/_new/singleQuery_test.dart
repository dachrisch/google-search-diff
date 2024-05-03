import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/page/results_scaffold.dart';
import 'package:google_search_diff/_new/widget/result_card.dart';
import 'package:provider/provider.dart';

import 'util/testProvider.dart';
import 'widget_tester_extension.dart';

void main() {
  testWidgets('Refresh adds a new result and then deletes it',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var searchQuery = QueryModel(Query('Test query'));
    await tester.pumpWidget(ScaffoldValueProviderTestApp<QueryModel>(
      providedValue: searchQuery,
      scaffoldUnderTest: const ResultsScaffold(),
    ));

    expect(find.byType(QueryResultCard), findsNWidgets(0));
    expect(searchQuery.items, 0);

    await tester.tapButtonByKey('refresh-query-results-button');
    expect(searchQuery.items, 1);
    expect(find.byType(QueryResultCard), findsNWidgets(1));

    await tester.tapButtonByKey(
        'delete-query-results-${searchQuery.resultsAt(0).resultsId}');
    expect(searchQuery.items, 0);
    expect(find.byType(QueryResultCard), findsNWidgets(0));
  });
}
