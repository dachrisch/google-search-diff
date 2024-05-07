import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/widget/query_card.dart';
import 'package:provider/provider.dart';

class QueryCardQueryModelProvider extends StatelessWidget {
  final QueryRunsModel queryRuns;
  final DateTime lastUpdated;

  const QueryCardQueryModelProvider(
      {super.key, required this.queryRuns, required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: queryRuns, child: SingleQueryCard(lastUpdated: lastUpdated));
  }
}
