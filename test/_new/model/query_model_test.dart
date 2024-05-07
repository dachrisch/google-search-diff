import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/comparison.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results.dart';

void main() {
  test('Finds the next recent run', () async {
    var query = Query('Test');
    QueryRunsModel queryRunsModel = QueryRunsModel(query);
    Results first = Results(query, [ResultModel(title: 'test1')],
        runDate: DateTime(2000, 1, 1));
    Results second = Results(query, [ResultModel(title: 'test1')],
        runDate: DateTime(2000, 1, 2));
    await queryRunsModel.addRun(first);
    await queryRunsModel.addRun(second);

    expect(queryRunsModel.nextRecentTo(second), first);
    expect(queryRunsModel.nextRecentTo(first), first);
  });

  test('Compares two runs: Both equal', () {
    var query = Query('Test');
    Results first = Results(query, [ResultModel(title: 'test1')],
        runDate: DateTime(2000, 1, 1));
    Results second = Results(query, [ResultModel(title: 'test1')],
        runDate: DateTime(2000, 1, 2));
    expect(first.compareTo(second),
        ResultComparison(existing: [ResultModel(title: 'test1')]));
  });
  test('Compares two runs: One added', () {
    var query = Query('Test');
    Results first = Results(query, [ResultModel(title: 'test1')],
        runDate: DateTime(2000, 1, 1));
    Results second = Results(
        query,
        [ResultModel(title: 'test1'), ResultModel(title: 'test2')],
        runDate:  DateTime(2000, 1, 2));
    expect(
        first.compareTo(second),
        ResultComparison(
            existing: [ResultModel(title: 'test1')],
            added: [ResultModel(title: 'test2')]));
  });
  test('Compares two runs: One removed', () {
    var query = Query('Test');
    Results first = Results(query, [ResultModel(title: 'test1')],
        runDate: DateTime(2000, 1, 1));
    Results second = Results(
        query,
        [ResultModel(title: 'test1'), ResultModel(title: 'test2')],
        runDate:  DateTime(2000, 1, 2));
    expect(
        second.compareTo(first),
        ResultComparison(
            existing: [ResultModel(title: 'test1')],
            removed: [ResultModel(title: 'test2')]));
  });
}
