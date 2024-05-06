import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/service/db_service.dart';

class QueriesStoreModel extends ChangeNotifier {
  final DbService dbService;
  final List<QueryRunsModel> searchQueries = [];
  final FimberLog l = FimberLog('QueriesStore');

  QueriesStoreModel({required this.dbService});

  int get items => searchQueries.length;

  void loadQueries(List<Query>? queries) {
    l.d('Loading [${queries?.length}] Queries');
    searchQueries.clear();
    queries?.forEach((element) => searchQueries.add(QueryRunsModel(element)));
  }

  Future<void> add(QueryRunsModel queryModel) => dbService
      .addQuery(queryModel.query)
      .then((_) => searchQueries.add(queryModel))
      .then((_) => l.d('Added $queryModel to Queries'))
      .then((_) => notifyListeners());

  Future<void> remove(QueryRunsModel queryModel) => dbService
      .removeQuery(queryModel.query)
      .then((_) => searchQueries.remove(queryModel))
      .then((_) => l.d('Removed $queryModel from Queries'))
      .then((_) => notifyListeners());

  QueryRunsModel at(int index) => searchQueries[index];

  QueryRunsModel findById(QueryId queryId) =>
      searchQueries.firstWhere((element) => element.query.queryId == queryId);
}
