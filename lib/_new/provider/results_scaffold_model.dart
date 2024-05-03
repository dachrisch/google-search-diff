import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/page/runs_scaffold.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:provider/provider.dart';

class ResultsScaffoldQueryModelProvider extends StatelessWidget {
  const ResultsScaffoldQueryModelProvider({super.key});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    QueryRunsModel queryRuns =
        context.select<QueriesStoreModel, QueryRunsModel>(
            (store) => store.findById(queryId));

    return ChangeNotifierProvider.value(
        value: queryRuns, child: const RunsScaffold());
  }
}
