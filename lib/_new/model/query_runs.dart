import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/model/run_id.dart';

class QueryRunsModel extends ChangeNotifier {
  final Query query;
  final SplayTreeSet<RunModel> runs;

  static QueryRunsModel fromRunModel(RunModel runModel) {
    return QueryRunsModel(runModel.query,
        runs: SplayTreeSet.of([runModel],
            (key1, key2) => RunModel.compare(key1, key2, reverse: true)));
  }

  QueryRunsModel(this.query, {SplayTreeSet<RunModel>? runs})
      : runs = runs ??
            SplayTreeSet<RunModel>(
                (key1, key2) => RunModel.compare(key1, key2, reverse: true));

  int get items => runs.length;

  RunModel runAt(int index) => runs.elementAt(index);

  RunModel get latest => runs.reduce((current, next) =>
      current.queryDate.isAfter(next.queryDate) ? current : next);

  addRun(RunModel run) {
    runs.add(run);
    notifyListeners();
  }

  removeRun(RunModel run) {
    runs.remove(run);
    notifyListeners();
  }

  RunModel findById(RunId runId) =>
      runs.firstWhere((value) => value.runId == runId);

  @override
  String toString() {
    return 'QueryRunsModel(query: $query)';
  }
}
