import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query_runs.g.dart';

@JsonSerializable()
class QueryRunsModel extends ChangeNotifier {
  final Query query;
  final List<RunModel> runs;

  static QueryRunsModel fromRunModel(RunModel runModel) => QueryRunsModel(runModel.query, runs: [runModel]);


  QueryRunsModel(this.query, {List<RunModel>? runs}) : runs = runs ?? [];

  int get items => runs.length;

  RunModel runAt(int index) => runs.elementAt(index);

  RunModel get latest => runs.reduce((current, next) =>
      current.queryDate.isAfter(next.queryDate) ? current : next);

  addRun(RunModel run) {
    runs.add(run);
    notifyListeners();
  }

  removeRun(RunModel run) {
    runs.remove(run);
    notifyListeners();
  }

  @override
  String toString() => 'QueryRuns(query: $query, runs: $runs)';

  RunModel findById(RunId runId) =>
      runs.firstWhere((value) => value.runId == runId);

  factory QueryRunsModel.fromJson(Map<String, dynamic> json) =>
      _$QueryRunsModelFromJson(json);

  Map<String, dynamic> toJson() => _$QueryRunsModelToJson(this);
}
