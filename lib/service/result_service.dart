import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/result_id.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class ResultService {
  final DbRunsService dbRunsService;
  final QueriesStore queriesStore;

  ResultService({required this.dbRunsService, required this.queriesStore});

  Result byId(ResultId resultId) => dbRunsService
      .fetchAll()
      .expand((run) => run.results)
      .firstWhere((result) => result.id == resultId);

  Run latestRunOf(Result result) =>
      dbRunsService.fetchAll().firstWhere((r) => r.results.contains(result));

  List<ResultHistory> historyOf(Result result) {
    List<ResultHistory> history = [];
    Query query = latestRunOf(result).query;
    QueryRuns queryRuns = queriesStore.findById(query.id);
    List<Run> runHistory = List.from(queryRuns.runs);
    runHistory.sort((a, b) => a.runDate.compareTo(b.runDate));

    bool wasInPreviousRun = false;
    // Go through each run to determine the status of the result
    for (var run in runHistory) {
      bool isInCurrentRun = run.results.contains(result);
      if (isInCurrentRun) {
        if (wasInPreviousRun) {
          history.add(
              ResultHistory(run: run, comparedResult: ExistingResult(result)));
        } else {
          history.add(
              ResultHistory(run: run, comparedResult: AddedResult(result)));
        }
      } else {
        if (wasInPreviousRun) {
          history.add(
              ResultHistory(run: run, comparedResult: RemovedResult(result)));
        } else {
          // not in current run, not in run before --> never seen before, skip
        }
      }

      wasInPreviousRun = isInCurrentRun;
    }

    return history.reversed.toList();
  }
}

class ResultHistory {
  final ComparedResult comparedResult;
  final Run run;

  ResultHistory({required this.run, required this.comparedResult});
}
