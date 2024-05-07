import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';

class SearchIntent extends Intent {
  final QueryRuns queryRuns;

  const SearchIntent(this.queryRuns);
}
