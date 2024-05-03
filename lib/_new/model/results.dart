import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results_id.dart';

class ResultsModel {
  final DateTime queryDate;
  final ResultsId resultsId;
  final Query query;
  final List<ResultModel> results;

  ResultsModel(this.query, this.results)
      : queryDate = DateTime.now(),
        resultsId = ResultsId.withUuid();

  static ResultsModel empty() => ResultsModel(Query.empty(), []);
}
