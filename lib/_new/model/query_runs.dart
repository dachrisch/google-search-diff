import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';

class QueryRunsModel extends ChangeNotifier {
  final Query query;
  final List<RunModel> runs;
  final DbRunsService dbRunsService=DbRunsService();

  static QueryRunsModel fromRunModel(RunModel runModel) =>
      QueryRunsModel(runModel.query, runs: [runModel]);

  QueryRunsModel(this.query, {List<RunModel>? runs}) : runs = runs ?? [];

  int get items => runs.length;

  RunModel runAt(int index) => runs.elementAt(index);

  RunModel get latest => runs.reduce((current, next) =>
      current.queryDate.isAfter(next.queryDate) ? current : next);

  Future<void> addRun(RunModel run) =>
    dbRunsService.saveQueryRun(run).then((value) => runs.add(run)).then((value) => notifyListeners());

  removeRun(RunModel run) =>
    dbRunsService.removeQueryRun(run).then((value) => runs.remove(run)).then((value) => notifyListeners());

  @override
  String toString() => 'QueryRuns(query: $query, runs: $runs)';

  RunModel findById(RunId runId) =>
      runs.firstWhere((value) => value.runId == runId);
}
