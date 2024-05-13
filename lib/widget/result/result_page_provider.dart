import 'package:flutter/material.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/model/run_id.dart';
import 'package:google_search_diff/routes/query_id.dart';
import 'package:google_search_diff/widget/result/results_page.dart';
import 'package:provider/provider.dart';

class ResultsPageResultsProvider extends StatelessWidget {
  const ResultsPageResultsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    RunId resultsId = context.read<RunId>();
    QueriesStore queriesStore = context.read<QueriesStore>();
    Run resultsModel = queriesStore.findById(queryId).findById(resultsId);
    return ChangeNotifierProvider.value(
        value: resultsModel, child: const ResultsPageScaffold());
  }
}
