import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/page/results_scaffold.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:provider/provider.dart';

class ResultsScaffoldQueryModelProvider extends StatelessWidget {
  const ResultsScaffoldQueryModelProvider({super.key});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    QueryModel searchQuery = context.select<QueriesStoreModel, QueryModel>(
        (store) => store.findById(queryId));

    return ChangeNotifierProvider.value(
        value: searchQuery, child: const ResultsScaffold());
  }
}
