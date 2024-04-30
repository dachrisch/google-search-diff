import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/queryResults.dart';
import 'package:google_search_diff/_new/routes/queryId.dart';

class SearchQueryModel extends ChangeNotifier {
  final String query;
  final List<QueryResultsModel> _results = [];
  final QueryId queryId;

  SearchQueryModel(this.query) : queryId = QueryId.withUuid();

  int get items => _results.length;

  QueryResultsModel resultsAt(int index) => _results[index];

  addResults(QueryResultsModel queryResults) {
    _results.add(queryResults);
    notifyListeners();
  }

  removeResults(QueryResultsModel queryResults) {
    _results.remove(queryResults);
    notifyListeners();
  }
}
