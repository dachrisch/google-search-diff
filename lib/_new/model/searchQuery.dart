import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/routes/routes.dart';

class SearchQueryModel extends ChangeNotifier {
  final String query;
  final List<QueryResults> results = [];

  final QueryId queryId;

  SearchQueryModel(this.query) : queryId = QueryId.withUuid();

  QueryResults resultsAt(int index) => results[index];

  addResults(QueryResults queryResults) {
    results.add(queryResults);
    notifyListeners();
  }

  removeResults(QueryResults queryResults) {
    results.remove(queryResults);
    notifyListeners();
  }
}

class QueryResults {
  final DateTime queryDate;

  QueryResults() : queryDate = DateTime.now();
}
