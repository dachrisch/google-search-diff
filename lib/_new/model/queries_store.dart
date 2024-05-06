import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';

class QueriesStoreModel extends ChangeNotifier {
  final List<QueryRunsModel> searchQueries = [];
  final DbQueriesService dbQueryService = DbQueriesService();
  final DbRunsService dbRunsService = DbRunsService();

  QueriesStoreModel() {
    dbQueryService.fetchAllQueries().then((allQueries) => allQueries.forEach(
        (query) => dbRunsService
            .fetchRunsForQuery(query)
            .then((runs) => searchQueries.addAll(runs))));
  }

  int get items => searchQueries.length;

  Future<void> add(QueryRunsModel queryRuns) {
    return Future.sync(() => searchQueries.add(queryRuns))
        .then((_) => dbQueryService.saveQuery(queryRuns.query))
        .then((_) => dbRunsService.saveQueryRuns(queryRuns))
        .then((value) => notifyListeners());
  }

  Future<void> remove(QueryRunsModel queryRuns) =>
      Future.sync(() => searchQueries.remove(queryRuns))
          .then((_) => dbQueryService.removeQuery(queryRuns.query))
          .then((_) => dbRunsService.removeQueryRuns(queryRuns))
          .then((value) => notifyListeners());

  QueryRunsModel at(int index) => searchQueries[index];

  QueryRunsModel findById(QueryId queryId) =>
      searchQueries.firstWhere((element) => element.query.queryId == queryId);
}
