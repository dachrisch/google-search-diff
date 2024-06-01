import 'package:flutter/foundation.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/routes/query_id.dart';
import 'package:google_search_diff/service/db_queries_service.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class QueriesStore extends ChangeNotifier {
  final List<QueryRuns> queryRuns = [];
  final DbQueriesService dbQueryService;
  final DbRunsService dbRunsService;
  final Logger l = getLogger('QueriesStore');

  QueriesStore({required this.dbQueryService, required this.dbRunsService}) {
    for (var query in dbQueryService.fetchAll()) {
      var runs =
          dbRunsService.fetchAll().where((run) => run.query == query).toList();
      queryRuns.add(QueryRuns.fromTransientRuns(query, runs, dbRunsService));
    }
  }

  int get items => queryRuns.length;

  Future<QueryRuns> addQueryRuns(QueryRuns runs) {
    return Future(() => queryRuns.add(runs))
        .then((_) => dbRunsService.saveAll(runs.runs))
        .then((_) => dbQueryService.save(runs.query))
        .then((_) => notifyListeners())
        .then((_) => runs);
  }

  Future<void> removeQueryRuns(QueryRuns runs) =>
      Future.sync(() => queryRuns.remove(runs))
          .then((_) => runs.removeAllRuns())
          .then((_) => dbQueryService.remove(runs.query))
          .then((_) => notifyListeners());

  QueryRuns at(int index) => queryRuns[index];

  QueryRuns findById(QueryId queryId) =>
      queryRuns.firstWhere((element) => element.query.id == queryId);
}
