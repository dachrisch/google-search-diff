import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/service/db_queries_service.dart';

import '../util/service_mocks.dart';

void main() {
  test('Queries are initialized from DB', () async {
    var fromDb = await DbQueriesService.fromDb(MockLocalStore());
    expect(fromDb.itemToIdMap.length, 1);
  });
  test('QueriesStore is loaded from DB', () async {
    var mockLocalStore = MockLocalStore();
    var fromDb = await DbQueriesService.fromDb(mockLocalStore);
    var store = QueriesStore(
        dbQueryService: fromDb, dbRunsService: MockDbRunsService());
    expect(store.items, 1);
  });

  test('Remove Query and runs', () async {
    var runsService = MockDbRunsService();
    var store = QueriesStore(
        dbQueryService: MockDbQueriesService(), dbRunsService: runsService);
    var query = Query('test12');
    var queryRuns =
        QueryRuns.fromRun(Run(query, [Result(title: 'Test1')]), runsService);
    await store.addQueryRuns(queryRuns);
    expect(store.items, 1);
    expect(runsService.fetchAll().length, 1);
    await store.removeQueryRuns(queryRuns);
    expect(store.items, 0);
    expect(runsService.fetchAll().length, 0);
  });
}
