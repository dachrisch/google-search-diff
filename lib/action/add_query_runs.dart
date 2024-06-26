import 'package:flutter/material.dart';
import 'package:google_search_diff/action/intent/add_run_to_query_runs.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query_runs.dart';

class AddQueryRunsAction extends Action<AddRunToQueryRunsIntent> {
  final QueriesStore queriesStore;

  AddQueryRunsAction(this.queriesStore);

  @override
  Object? invoke(AddRunToQueryRunsIntent intent) =>
      queriesStore.addQueryRuns(getIt<QueryRuns>(param1: intent.run));
}
