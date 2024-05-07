import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results.dart';

import '../util/localstore_helper.dart';

void main() {
  setUp(() => cleanupBefore(['.queries', '.runs']));
  test('Loads one query run', () async {
    Directory('.queries').createSync();
    Directory('.runs').createSync();
    var query = Query('Test Store');
    File('.queries/123456789').writeAsStringSync(jsonEncode(query));
    File('.runs/987654321').writeAsStringSync(
        jsonEncode(Results(query, [ResultModel(title: 'Test title')])));
    File('.runs/987654322').writeAsStringSync(
        jsonEncode(Results(query, [ResultModel(title: 'Test title 2')])));
    var searchQueriesStore = QueriesStoreModel();
    await searchQueriesStore.initFuture.then((value) async {
      await searchQueriesStore.dbRunsService.loadFuture;
      expect(searchQueriesStore.searchQueries.length, 1);
      expect(searchQueriesStore.searchQueries[0].runs.length, 2);
      expect(searchQueriesStore.searchQueries[0].runs[0].results.length, 1);
    });
  });

  test('Loads one query run after adding', () async {
    var store = QueriesStoreModel();
    var query = Query('Test Store');
    var runs = QueryRunsModel(query);
    runs.addRun(Results(query, [ResultModel(title: 'Test1')]));
    await store.add(runs);
    runs.addRun(Results(query, [ResultModel(title: 'Test2')]));

    var searchQueriesStore = QueriesStoreModel();
    await searchQueriesStore.initFuture.then((value) {
      expect(searchQueriesStore.searchQueries.length, 1);
      expect(searchQueriesStore.searchQueries[0].runs.length, 2);
      expect(searchQueriesStore.searchQueries[0].runs[0].results.length, 1);
      expect(searchQueriesStore.searchQueries[0].runs[1].results.length, 1);
    });
  });
}
