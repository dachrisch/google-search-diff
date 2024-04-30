import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/model/searchQueryStore.dart';
import 'package:provider/provider.dart';

class SingleQueryView extends StatelessWidget {
  const SingleQueryView({
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
          onTap: () => context.go('/queries/${searchQuery.queryId.queryId}'),
          child: ListTile(
            leading: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white))),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {},
              ),
            ),
            title: Text(searchQuery.query),
            subtitle: Column(
              children: [Text('Results: ${searchQuery.results.length}')],
            ),
            trailing: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 1.0, color: Colors.white))),
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => searchQueriesStore.remove(searchQuery),
                )),
          )),
    );
  }
}