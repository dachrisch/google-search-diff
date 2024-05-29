import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/queries_store_export.dart';
import 'package:injectable/injectable.dart';

@singleton
class QueriesStoreExportService {
  final QueriesStore queriesStore;

  QueriesStoreExportService({required this.queriesStore});

  QueriesStoreExport export() {
    return QueriesStoreExport(
        runs: queriesStore.queryRuns.expand((queryRun) => queryRun.runs));
  }
}
