import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/page/singleQueryScaffold.dart';
import 'package:google_search_diff/_new/widget/queryResultsCard.dart';
import 'package:provider/provider.dart';

import 'util/testProvider.dart';
import 'widget_tester_extension.dart';

void main() {
  testWidgets('Adds a single query and removes it',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var searchQuery = SearchQueryModel('Test query');
    await tester.pumpWidget(ScaffoldValueProviderTestApp<SearchQueryModel>(
      providedValue: searchQuery,
      scaffoldUnderTest: const SingleQueryScaffold(),
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
