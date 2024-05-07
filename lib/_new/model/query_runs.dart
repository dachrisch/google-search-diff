import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';

class QueryRunsModel extends ChangeNotifier {
  final Query query;
  final List<Results> runs;
  final DbRunsService dbRunsService = DbRunsService();

  static QueryRunsModel fromRunModel(Results runModel) {
    var queryRunsModel = QueryRunsModel(runModel.query);
    queryRunsModel.addRun(runModel);
    return queryRunsModel;
  }

  QueryRunsModel(this.query, {List<Results>? runs}) : runs = runs ?? [];

  int get items => runs.length;

  Results runAt(int index) => runs.elementAt(index);

  Results? get latest => runs.reduce((current, next) =>
      current.runDate.isAfter(next.runDate) ? current : next);

  Future<void> addRun(Results run) => dbRunsService
      .saveQueryRun(run)
      .then((value) => runs.add(run))
      .then((value) => notifyListeners());

  removeRun(Results run) => dbRunsService
      .removeQueryRun(run)
      .then((value) => runs.remove(run))
      .then((value) => notifyListeners());

  @override
  String toString() => 'QueryRuns(query: $query, runs: $runs)';

  Results findById(RunId runId) =>
      runs.firstWhere((value) => value.runId == runId);

  Results nextRecentTo(Results run) =>
      runs.fold<Results?>(
          null,
          (closest, element) => element.runDate.isBefore(run.runDate) &&
                  (closest == null ||
                      run.runDate.difference(element.runDate) <
                          run.runDate.difference(closest.runDate))
              ? element
              : closest) ??
      run;
}
