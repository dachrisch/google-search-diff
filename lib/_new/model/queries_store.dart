import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class QueriesStore extends ChangeNotifier {
  final List<QueryRuns> queryRuns = [];
  final DbQueriesService dbQueryService;
  final DbRunsService dbRunsService;
  final Logger l = getLogger('QueriesStore');

  QueriesStore({required this.dbQueryService, required this.dbRunsService});

  int get items => queryRuns.length;

  Future<void> add(QueryRuns runs) {
    return Future.sync(() => queryRuns.add(runs))
        .then((_) => dbQueryService.saveQuery(runs.query))
        .then((value) => notifyListeners());
  }

  Future<void> remove(QueryRuns runs) =>
      Future.sync(() => queryRuns.remove(runs))
          .then((_) => dbQueryService.removeQuery(runs.query))
          .then((_) => dbRunsService.removeRuns(runs.runs))
          .then((value) => notifyListeners());

  QueryRuns at(int index) => queryRuns[index];

  QueryRuns findById(QueryId queryId) =>
      queryRuns.firstWhere((element) => element.query.id == queryId);
}
