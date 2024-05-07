import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comparison.dart';

part 'results.g.dart';

@JsonSerializable()
class Results extends ChangeNotifier {
  final DateTime runDate;
  final RunId runId;
  final Query query;
  final List<ResultModel> results;

  Results(this.query, this.results, {DateTime? runDate, RunId? runId})
      : runDate = runDate ?? DateTime.now(),
        runId = runId ?? RunId.withUuid();

  int get items => results.length;

  static Results empty() => Results(Query.empty(), []);

  static int compare(Results a, Results b, {bool reverse = false}) =>
      (reverse ? -1 : 1) * a.runDate.compareTo(b.runDate);

  ResultModel operator [](int index) {
    return results[index];
  }

  @override
  String toString() => 'Run(id: $runId, date: $runDate)';

  factory Results.fromJson(Map<String, dynamic> json) =>
      _$ResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsToJson(this);

  ResultComparison compareTo(Results run) {
    ResultComparison resultComparison = ResultComparison();
    for (var result in run.results) {
      if (results.contains(result)) {
        resultComparison.existing.add(result);
      } else {
        resultComparison.added.add(result);
      }
    }
    for (var result in results) {
      if (!run.results.contains(result)) {
        resultComparison.removed.add(result);
      }
    }
    return resultComparison;
  }
}
