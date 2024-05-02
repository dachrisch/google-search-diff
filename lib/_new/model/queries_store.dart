import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';

class QueriesStoreModel extends ChangeNotifier {
  final List<QueryModel> searchQueries = [];

  int get items => searchQueries.length;

  void add(Query query) {
    searchQueries.add(QueryModel(query));
    notifyListeners();
  }

  void remove(QueryModel searchQuery) {
    searchQueries.remove(searchQuery);
    notifyListeners();
  }

  QueryModel at(int index) => searchQueries[index];

  QueryModel findById(QueryId queryId) =>
      searchQueries.firstWhere((element) => element.queryId == queryId);
}
