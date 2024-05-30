import 'package:flutter/material.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/model/run_id.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class QueryRuns extends ChangeNotifier {
  final Query query;
  final List<Run> runs;
  final DbRunsService dbRunsService;

  @factoryMethod
  static QueryRuns fromRun(
          @factoryParam Run run, DbRunsService dbRunsService) =>
      QueryRuns.fromTransientRuns(run.query, [run], dbRunsService);

  factory QueryRuns.fromTransientRuns(Query query, Iterable<Run> runs,
      DbRunsService dbRunsService) {
    var queryRuns = QueryRuns._(query, dbRunsService: dbRunsService);
    queryRuns.runs.addAll(runs);
    return queryRuns;
  }

  factory QueryRuns.clone(QueryRuns other) => QueryRuns._(other.query,
      dbRunsService: other.dbRunsService, runs: List.from(other.runs));

  QueryRuns._(this.query, {required this.dbRunsService, List<Run>? runs})
      : runs = runs ?? [];

  int get items => runs.length;

  Run runAt(int index) => runs.elementAt(index);

  Run? get latest => runs.isNotEmpty
      ? runs.reduce((current, next) =>
          current.runDate.isAfter(next.runDate) ? current : next)
      : null;

  void addRuns(List<Run> runs) => runs.forEach(addRun);

  Future<Run> addRun(Run run) => dbRunsService
      .save(run)
      .then((value) => runs.add(run))
      .then((value) => notifyListeners())
      .then((_) => run);

  void removeAllRuns() => runs.forEach(removeRun);

  Future<void> removeRun(Run run) => dbRunsService
      .remove(run)
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
