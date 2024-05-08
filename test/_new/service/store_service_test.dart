import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';
import 'package:google_search_diff/_new/service/localstore.dart';

import '../util/localstore_helper.dart';

void main() {
  setUp(() => cleanupBefore(['.queries', '.runs']));
  test('Loads one query run', () async {
    Directory('.queries').createSync();
    Directory('.runs').createSync();
    var query = Query('Test Store');
    File('.queries/123456789').writeAsStringSync(jsonEncode(query));
    File('.runs/987654321').writeAsStringSync(
        jsonEncode(Run(query, [Result(title: 'Test title')])));
    File('.runs/987654322').writeAsStringSync(
        jsonEncode(Run(query, [Result(title: 'Test title 2')])));

    await () async {
      var localStoreService = LocalStoreService();
      var searchQueriesStore = QueriesStore(
          dbQueryService: await DbQueriesService.fromDb(localStoreService),
          dbRunsService: await DbRunsService.fromDb(localStoreService));
      expect(searchQueriesStore.queryRuns.length, 1);
      expect(searchQueriesStore.queryRuns[0].runs.length, 2);
      expect(searchQueriesStore.queryRuns[0].runs[0].results.length, 1);
    };
  });
}
