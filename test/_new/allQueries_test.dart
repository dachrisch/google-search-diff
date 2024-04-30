import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/searchQueryStore.dart';
import 'package:google_search_diff/_new/page/allQueriesScaffold.dart';
import 'package:google_search_diff/_new/widget/singleQueryCard.dart';
import 'package:provider/provider.dart';

import 'widget_tester_extension.dart';

void main() {
  testWidgets('Adds a single query and removes it',
      (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;
    var searchQueriesStore = SearchQueriesStore();
    await tester.pumpWidget(ScaffoldValueProviderTestApp<SearchQueriesStore>(
      providedValue: searchQueriesStore,
      scaffoldUnderTest: const AllQueriesScaffold(),
    ));

    expect(find.byType(SingleQueryCard), findsNWidgets(0));
    expect(searchQueriesStore.items, 0);

    await tester.tapButtonByKey('add-search-query-button');
    expect(searchQueriesStore.items, 1);
    expect(find.byType(SingleQueryCard), findsNWidgets(1));

    await tester.tapButtonByKey('delete-search-query-${searchQueriesStore.at(0).queryId}');
    expect(searchQueriesStore.items, 0);
    expect(find.byType(SingleQueryCard), findsNWidgets(0));
  });
}

class ScaffoldValueProviderTestApp<T extends ChangeNotifier>
    extends StatelessWidget {
  final Widget scaffoldUnderTest;
  final T providedValue;

  const ScaffoldValueProviderTestApp({
    super.key,
    required this.providedValue,
    required this.scaffoldUnderTest,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChangeNotifierProvider<T>.value(
            value: providedValue, child: scaffoldUnderTest));
  }
}
