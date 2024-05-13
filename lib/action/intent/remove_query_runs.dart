import 'package:flutter/material.dart';
import 'package:google_search_diff/model/query_runs.dart';

class RemoveQueryRunsIntent extends Intent {
  final QueryRuns queryRuns;

  const RemoveQueryRunsIntent({required this.queryRuns});
}
