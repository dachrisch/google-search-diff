import 'package:google_search_diff/_new/model/resultsId.dart';

class QueryResultsModel {
  final DateTime queryDate;
  final ResultsId resultsId;

  QueryResultsModel()
      : queryDate = DateTime.now(),
        resultsId = ResultsId.withUuid();
}
