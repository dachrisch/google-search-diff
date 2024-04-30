import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:provider/provider.dart';

class SingleQueryCard extends StatelessWidget {
  const SingleQueryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QueryModel searchQuery = context.watch<QueryModel>();

    QueriesStoreModel searchQueriesStore = context.watch<QueriesStoreModel>();

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
                onPressed: () => searchQuery.addResults(ResultsModel()),
              ),
            ),
            title: Text(searchQuery.query.query),
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
