import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/service/history_service.dart';

import '../util/service_mocks.dart';

void main() {
  test('No duplicates in history', () async {
    var history = HistoryService(dbHistoryService: MockDbHistoryService());
    await history.addQuery(Query('Test 1'));
    await history.addQuery(Query('Test 2'));
    await history.addQuery(Query('Test 1'));
    expect(history.queries.length, 2);
  });
}
