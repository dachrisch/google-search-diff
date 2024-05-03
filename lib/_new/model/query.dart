import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';

class QueryModel extends ChangeNotifier {
  final Query query;
  final List<ResultsModel> results;
  final QueryId queryId;

  static QueryModel fromResultsModel(ResultsModel resultsModel) {
    return QueryModel(resultsModel.query, results: [resultsModel]);
  }

  QueryModel(this.query, {List<ResultsModel>? results})
      : results = results ?? List<ResultsModel>.empty(growable: true),
        queryId = QueryId.withUuid();

  int get items => results.length;

  ResultsModel resultsAt(int index) => results[index];

  addResults(ResultsModel queryResults) {
    results.add(queryResults);
    notifyListeners();
  }

  removeResults(ResultsModel queryResults) {
    results.remove(queryResults);
    notifyListeners();
  }
}

class Query {
  final String query;

  Query(this.query);

  @override
  int get hashCode => query.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Query && other.query == query;
  }

  @override
  String toString() => query.toString();

  static Query empty() => Query('');
}
