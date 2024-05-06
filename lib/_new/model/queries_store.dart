import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';

class QueriesStoreModel extends ChangeNotifier {
  final List<QueryRunsModel> searchQueries = [];

  int get items => searchQueries.length;

  void add(QueryRunsModel queryModel) {
    searchQueries.add(queryModel);
    notifyListeners();
  }

  void remove(QueryRunsModel searchQuery) {
    searchQueries.remove(searchQuery);
    notifyListeners();
  }

  QueryRunsModel at(int index) => searchQueries[index];

  QueryRunsModel findById(QueryId queryId) =>
      searchQueries.firstWhere((element) => element.query.id == queryId);
}
