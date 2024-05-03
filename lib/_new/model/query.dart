import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/model/results_id.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';

class QueryModel extends ChangeNotifier {
  final Query query;
  final SplayTreeSet<ResultsModel> results;
  final QueryId queryId;

  static QueryModel fromResultsModel(ResultsModel resultsModel) {
    return QueryModel(resultsModel.query,
        results: SplayTreeSet.of([resultsModel],
            (key1, key2) => ResultsModel.compare(key1, key2, reverse: true)));
  }

  QueryModel(this.query, {SplayTreeSet<ResultsModel>? results})
      : results = results ??
            SplayTreeSet<ResultsModel>((key1, key2) =>
                ResultsModel.compare(key1, key2, reverse: true)),
        queryId = QueryId.withUuid();

  int get items => results.length;

  ResultsModel resultsAt(int index) => results.elementAt(index);

  ResultsModel get latest => results.reduce((current, next) =>
      current.queryDate.isAfter(next.queryDate) ? current : next);

  addResults(ResultsModel queryResults) {
    results.add(queryResults);
    notifyListeners();
  }

  removeResults(ResultsModel queryResults) {
    results.remove(queryResults);
    notifyListeners();
  }

  ResultsModel findById(ResultsId resultsId) =>
      results.firstWhere((value) => value.resultsId == resultsId);
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
