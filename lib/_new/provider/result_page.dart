import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:google_search_diff/_new/page/results_page.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
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
