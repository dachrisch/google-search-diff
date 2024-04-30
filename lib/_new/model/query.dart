import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/routes/routes.dart';

class QueryModel extends ChangeNotifier {
  final Query query;
  final List<ResultsModel> _results = [];
  final QueryId queryId;

  QueryModel(this.query) : queryId = QueryId.withUuid();

  int get items => _results.length;

  ResultsModel resultsAt(int index) => _results[index];

  addResults(ResultsModel queryResults) {
    _results.add(queryResults);
    notifyListeners();
  }

  removeResults(ResultsModel queryResults) {
    _results.remove(queryResults);
    notifyListeners();
  }
}
