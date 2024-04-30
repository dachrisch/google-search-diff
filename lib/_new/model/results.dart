import 'package:google_search_diff/_new/model/results_id.dart';

class ResultsModel {
  final DateTime queryDate;
  final ResultsId resultsId;

  ResultsModel()
      : queryDate = DateTime.now(),
        resultsId = ResultsId.withUuid();
}
