import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/queries_store_export.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/service/db_queries_service.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class QueriesStoreShareService {
  final QueriesStore queriesStore;
  final DbQueriesService dbQueriesService;
  final DbRunsService dbRunsService;

  QueriesStoreShareService(
      {required this.queriesStore,
      required this.dbRunsService,
      required this.dbQueriesService});

  QueriesStoreExport export() => QueriesStoreExport(
      runs: queriesStore.queryRuns.expand((queryRun) => queryRun.runs));

  Future<void> import(QueriesStoreExport queriesStoreExport) {
    dbQueriesService.removeAll(queriesStoreExport.queries);
    dbRunsService.removeAll(queriesStoreExport.runs);
    queriesStore.queryRuns.clear();
    return Future.forEach(
        queriesStoreExport.queries.map((query) => QueryRuns.fromTransientRuns(
            query,
            queriesStoreExport.runs.where((r) => r.query == query),
            dbRunsService)),
        (queryRuns) => queriesStore.addQueryRuns(queryRuns));
  }
}
