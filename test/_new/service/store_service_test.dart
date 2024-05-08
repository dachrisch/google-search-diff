import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';

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
    var searchQueriesStore = QueriesStore();
    await searchQueriesStore.initFuture.then((value) async {
      await searchQueriesStore.dbRunsService.loadFuture;
      expect(searchQueriesStore.queryRuns.length, 1);
      expect(searchQueriesStore.queryRuns[0].runs.length, 2);
      expect(searchQueriesStore.queryRuns[0].runs[0].results.length, 1);
    });
  });
}
