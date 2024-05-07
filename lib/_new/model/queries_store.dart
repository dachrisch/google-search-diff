import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';
import 'package:logger/logger.dart';

class QueriesStoreModel extends ChangeNotifier {
  final List<QueryRunsModel> searchQueries = [];
  final DbQueriesService dbQueryService = DbQueriesService();
  final DbRunsService dbRunsService = DbRunsService();
  final Logger l = getLogger('QueriesStore');
  late Future<void> initFuture;

  QueriesStoreModel() {
    initFuture = Future.sync(() => l.d('Loading all'))
        .then((_) => dbQueryService.fetchAllQueries().then((allQueries) async {
              for (var query in allQueries) {
                await dbRunsService.fetchRunsForQuery(query).then((runs) =>
                    searchQueries.add(QueryRunsModel(query, runs: runs)));
              }
              return allQueries;
            }))
        .then((_) => l.d('Finished loading'));
  }

  int get items => searchQueries.length;

  Future<void> add(QueryRunsModel queryRuns) {
    return Future.sync(() => searchQueries.add(queryRuns))
        .then((_) => dbQueryService.saveQuery(queryRuns.query))
        .then((value) => notifyListeners());
  }

  Future<void> remove(QueryRunsModel queryRuns) =>
      Future.sync(() => searchQueries.remove(queryRuns))
          .then((_) => dbQueryService.removeQuery(queryRuns.query))
          .then((_) => dbRunsService.removeQueryRuns(queryRuns.runs))
          .then((value) => notifyListeners());

  QueryRunsModel at(int index) => searchQueries[index];

  QueryRunsModel findById(QueryId queryId) =>
      searchQueries.firstWhere((element) => element.query.queryId == queryId);
}
