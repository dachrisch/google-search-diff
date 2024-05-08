import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';

import '../util/service_mocks.dart';

void main() {
  test('Queries are initialized', () async {
    var fromDb = await DbQueriesService.fromDb(MockLocalStore());
    expect(fromDb.itemToIdMap.length, 1);
  });
}
