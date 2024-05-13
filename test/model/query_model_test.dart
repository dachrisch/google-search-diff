import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';

import '../util/service_mocks.dart';

void main() {
  test('Finds the next recent run', () async {
    var query = Query('Test');
    Run first =
        Run(query, [Result(title: 'test1')], runDate: DateTime(2000, 1, 1));
    QueryRuns queryRunsModel = QueryRuns.fromRun(first, MockDbRunsService());
    Run second =
        Run(query, [Result(title: 'test1')], runDate: DateTime(2000, 1, 2));
    await queryRunsModel.addRun(first);
    await queryRunsModel.addRun(second);

    expect(queryRunsModel.nextRecentTo(second), first);
    expect(queryRunsModel.nextRecentTo(first), first);
  });

  test('Compares two runs: Both equal', () {
    var query = Query('Test');
    Run first =
        Run(query, [Result(title: 'test1')], runDate: DateTime(2000, 1, 1));
    Run second =
        Run(query, [Result(title: 'test1')], runDate: DateTime(2000, 1, 2));
    expect(first.compareTo(second).compared,
        contains(ExistingResult(Result(title: 'test1'))));
  });
  test('Compares two runs: One added', () {
    var query = Query('Test');
    Run first =
        Run(query, [Result(title: 'test1')], runDate: DateTime(2000, 1, 1));
    Run second = Run(query, [Result(title: 'test1'), Result(title: 'test2')],
        runDate: DateTime(2000, 1, 2));
    expect(first.compareTo(second).compared,
        contains(ExistingResult(Result(title: 'test1'))));
    expect(first.compareTo(second).compared,
        contains(AddedResult(Result(title: 'test2'))));
  });
  test('Compares two runs: One removed', () {
    var query = Query('Test');
    Run first =
        Run(query, [Result(title: 'test1')], runDate: DateTime(2000, 1, 1));
    Run second = Run(query, [Result(title: 'test1'), Result(title: 'test2')],
        runDate: DateTime(2000, 1, 2));
    expect(first.compareTo(second).compared,
        contains(ExistingResult(Result(title: 'test1'))));
    expect(first.compareTo(second).compared,
        contains(RemovedResult(Result(title: 'test2'))));
  });
}
