import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comparison.dart';

part 'run.g.dart';

@JsonSerializable()
class Run extends ChangeNotifier {
  final DateTime runDate;
  final RunId id;
  final Query query;
  final List<Result> results;

  Run(this.query, this.results, {DateTime? runDate, RunId? id})
      : runDate = runDate ?? DateTime.now(),
        id = id ?? RunId.withUuid();

  int get items => results.length;

  static Run empty() => Run(Query.empty(), []);

  static int compare(Run a, Run b, {bool reverse = false}) =>
      (reverse ? -1 : 1) * a.runDate.compareTo(b.runDate);

  Result operator [](int index) {
    return results[index];
  }

  @override
  String toString() => 'Run(id: $id, date: $runDate)';

  factory Run.fromJson(Map<String, dynamic> json) => _$RunFromJson(json);

  Map<String, dynamic> toJson() => _$RunToJson(this);

  ResultComparison compareTo(Run run) {
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
