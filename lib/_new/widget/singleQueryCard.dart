import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/queryResults.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/model/searchQueryStore.dart';
import 'package:provider/provider.dart';

class SingleQueryCard extends StatelessWidget {
  const SingleQueryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SearchQueryModel searchQuery = context.watch<SearchQueryModel>();

    SearchQueriesStore searchQueriesStore = context.watch<SearchQueriesStore>();

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
          onTap: () => context.go('/queries/${searchQuery.queryId}'),
          child: ListTile(
            leading: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white))),
              child: IconButton(
                key: const Key('refresh-query-results-outside-button'),
                icon: const Icon(Icons.refresh_outlined),
                onPressed: () => searchQuery.addResults(QueryResultsModel()),
              ),
            ),
            title: Text(searchQuery.query),
            subtitle: Column(
              children: [Text('Results: ${searchQuery.items}')],
            ),
            trailing: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 1.0, color: Colors.white))),
                child: IconButton(
                  key: Key('delete-search-query-${searchQuery.queryId}'),
                  icon: const Icon(Icons.delete),
                  onPressed: () => searchQueriesStore.remove(searchQuery),
                )),
          )),
    );
  }
}
