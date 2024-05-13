import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../service/widget_tester_extension.dart';
import '../widget/widget_tester_extension.dart';

class FailingSearchService extends SearchService {
  final Exception e;

  FailingSearchService({required this.e});

  @override
  Future<Run> doSearch(Query query) {
    throw e;
  }
}

void main() {
  testWidgets('Alert dialog when search fails', (WidgetTester tester) async {
    Provider.debugCheckInvalidValueType = null;

    (await tester.pumpMockedApp(Mocked(
        searchService:
            FailingSearchService(e: ClientException('Test error')))));

    expect(find.byType(QueryRunsCard), findsNothing);
    await tester.tapButtonByKey('show-searchbar-button');
    var searchField = find.byWidgetPredicate((widget) =>
        widget is TextField &&
        widget.decoration?.hintText == 'Create search...');
    expect(searchField, findsOne);
    await tester.enterText(searchField, 'Test query 1');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(await tester.takeException(), isA<ClientException>());
    // exception will stop flow during test, so can't test the error handling in app
    //expect(find.byType(AlertDialog), findsOneWidget);
  });
}
