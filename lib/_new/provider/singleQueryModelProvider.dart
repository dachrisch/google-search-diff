import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/model/searchQueryStore.dart';
import 'package:google_search_diff/_new/routes/queryId.dart';
import 'package:google_search_diff/_new/page/singleQueryScaffold.dart';
import 'package:provider/provider.dart';

class SingleQueryModelProvider extends StatelessWidget {
  const SingleQueryModelProvider({super.key});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    SearchQueryModel searchQuery =
        context.select<SearchQueriesStore, SearchQueryModel>(
            (store) => store.findById(queryId));

    return ChangeNotifierProvider.value(
        value: searchQuery, child: const SingleQueryScaffold());
  }
}
