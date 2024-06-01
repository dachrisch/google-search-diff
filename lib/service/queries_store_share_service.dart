import 'package:flutter/material.dart';
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

  Future<QueriesStoreExport?> importFrom(Map<String, dynamic>? json) {
    if (json != null) {
      var queriesStoreExport = QueriesStoreExport.fromJson(json);
      return Future.delayed(Durations.short1)
          .then((_) => dbQueriesService.removeAll(queriesStoreExport.queries))
          .then((_) => dbRunsService.removeAll(queriesStoreExport.runs))
          .then((_) => queriesStore.queryRuns
              .removeWhere((r) => queriesStoreExport.queries.contains(r.query)))
          .then((_) => Future.forEach(
              queriesStoreExport.queries.map((query) =>
                  QueryRuns.fromTransientRuns(
                      query,
                      queriesStoreExport.runs.where((r) => r.query == query),
                      dbRunsService)),
              (queryRuns) => queriesStore.addQueryRuns(queryRuns)))
          .then((_) => queriesStoreExport);
    } else {
      return Future.value(null);
    }
  }
}
