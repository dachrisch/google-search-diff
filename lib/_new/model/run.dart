import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'run.g.dart';

@JsonSerializable()
class RunModel extends ChangeNotifier {
  final DateTime queryDate;
  final RunId runId;
  final Query query;
  final List<ResultModel> results;

  RunModel(this.query, this.results, [DateTime? queryDate, RunId? runId])
      : queryDate = queryDate ?? DateTime.now(),
        runId = runId ?? RunId.withUuid();

  int get items => results.length;

  static RunModel empty() => RunModel(Query.empty(), []);

  static int compare(RunModel a, RunModel b, {bool reverse = false}) =>
      (reverse ? -1 : 1) * a.queryDate.compareTo(b.queryDate);

  ResultModel operator [](int index) {
    return results[index];
  }

  @override
  String toString() => 'Run(id: $runId, date: $queryDate)';

  factory RunModel.fromJson(Map<String, dynamic> json) =>
      _$RunModelFromJson(json);

  Map<String, dynamic> toJson() => _$RunModelToJson(this);
}
