import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/widget/model/comparison.dart';
import 'package:provider/provider.dart';

class QueryRunsPageProvider extends StatelessWidget {
  final Widget child;

  const QueryRunsPageProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    QueryRuns queryRuns = context
        .select<QueriesStore, QueryRuns>((store) => store.findById(queryId));

    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: queryRuns),
      Provider.value(value: ComparisonViewModel())
    ], child: child);
  }
}
