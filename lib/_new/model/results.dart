import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results_id.dart';

class ResultsModel extends ChangeNotifier {
  final DateTime queryDate;
  final ResultsId resultsId;
  final Query query;
  final List<ResultModel> results;

  ResultsModel(this.query, this.results)
      : queryDate = DateTime.now(),
        resultsId = ResultsId.withUuid();

  int get items => results.length;

  static ResultsModel empty() => ResultsModel(Query.empty(), []);

  static int compare(ResultsModel a, ResultsModel b, {bool reverse = false}) =>
      (reverse ? -1 : 1) * a.queryDate.compareTo(b.queryDate);

  ResultModel operator [](int index) {
    return results[index];
  }
}
