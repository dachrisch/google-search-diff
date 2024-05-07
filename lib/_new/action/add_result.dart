import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/intent/add_result_intent.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';

class AddResultsAction extends Action<AddResultsIntent> {
  final QueriesStoreModel queriesStore;

  AddResultsAction(this.queriesStore);

  @override
  Object? invoke(AddResultsIntent intent) =>
      queriesStore.add(QueryRunsModel.fromRunModel(intent.results));
}
