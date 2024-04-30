import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/queryResults.dart';
import 'package:google_search_diff/_new/routes/queryId.dart';
import 'package:google_search_diff/_new/routes/routes.dart';

class SearchQueryModel extends ChangeNotifier {
  final String query;
  final List<QueryResultsModel> results = [];

  final QueryId queryId;

  SearchQueryModel(this.query) : queryId = QueryId.withUuid();

  QueryResultsModel resultsAt(int index) => results[index];

  addResults(QueryResultsModel queryResults) {
    results.add(queryResults);
    notifyListeners();
  }

  removeResults(QueryResultsModel queryResults) {
    results.remove(queryResults);
    notifyListeners();
  }
}

