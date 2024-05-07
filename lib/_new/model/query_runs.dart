import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';

class QueryRuns extends ChangeNotifier {
  final Query query;
  final List<Run> runs;
  final DbRunsService dbRunsService = DbRunsService();

  static QueryRuns fromRun(Run run) {
    var runs = QueryRuns(run.query);
    runs.addRun(run);
    return runs;
  }

  QueryRuns(this.query, {List<Run>? runs}) : runs = runs ?? [];

  int get items => runs.length;

  Run runAt(int index) => runs.elementAt(index);

  Run? get latest => runs.reduce((current, next) =>
      current.runDate.isAfter(next.runDate) ? current : next);

  Future<void> addRun(Run run) => dbRunsService
      .saveRun(run)
      .then((value) => runs.add(run))
      .then((value) => notifyListeners());

  removeRun(Run run) => dbRunsService
      .removeRun(run)
      .then((value) => runs.remove(run))
      .then((value) => notifyListeners());

  @override
  String toString() => 'QueryRuns(query: $query, runs: $runs)';

  Run findById(RunId runId) => runs.firstWhere((value) => value.id == runId);

  Run nextRecentTo(Run run) =>
      runs.fold<Run?>(
          null,
          (closest, element) => element.runDate.isBefore(run.runDate) &&
                  (closest == null ||
                      run.runDate.difference(element.runDate) <
                          run.runDate.difference(closest.runDate))
              ? element
              : closest) ??
      run;
}
