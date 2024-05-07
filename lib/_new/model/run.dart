import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comparison.dart';

part 'run.g.dart';

@JsonSerializable()
class RunModel extends ChangeNotifier {
  final DateTime runDate;
  final RunId runId;
  final Query query;
  final List<ResultModel> results;

  RunModel(this.query, this.results, {DateTime? runDate, RunId? runId})
      : runDate = runDate ?? DateTime.now(),
        runId = runId ?? RunId.withUuid();

  int get items => results.length;

  static RunModel empty() => RunModel(Query.empty(), []);

  static int compare(RunModel a, RunModel b, {bool reverse = false}) =>
      (reverse ? -1 : 1) * a.runDate.compareTo(b.runDate);

  ResultModel operator [](int index) {
    return results[index];
  }

  @override
  String toString() => 'Run(id: $runId, date: $runDate)';

  factory RunModel.fromJson(Map<String, dynamic> json) =>
      _$RunModelFromJson(json);

  Map<String, dynamic> toJson() => _$RunModelToJson(this);

  ResultComparison compareTo(RunModel run) {
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
