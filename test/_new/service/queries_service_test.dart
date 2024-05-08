import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';

import '../util/service_mocks.dart';

void main() {
  test('Queries are initialized from DB', () async {
    var fromDb = await DbQueriesService.fromDb(MockLocalStore());
    expect(fromDb.itemToIdMap.length, 1);
  });
  test('QueriesStore is loaded from DB', () async {
    var fromDb = await DbQueriesService.fromDb(MockLocalStore());
    var store = QueriesStore(
        dbQueryService: fromDb, dbRunsService: MockDbRunsService());
    expect(store.items, 1);
  });
}
