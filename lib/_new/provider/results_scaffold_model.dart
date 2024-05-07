import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:provider/provider.dart';

class QueryRunsProvider extends StatelessWidget {
  final Widget child;

  const QueryRunsProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    QueryRuns queryRuns = context
        .select<QueriesStore, QueryRuns>((store) => store.findById(queryId));

    return ChangeNotifierProvider.value(value: queryRuns, child: child);
  }
}
