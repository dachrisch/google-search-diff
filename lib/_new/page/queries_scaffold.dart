import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/provider/query_card_model.dart';
import 'package:provider/provider.dart';

class QueriesScaffold extends StatelessWidget {
  const QueriesScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    QueriesStoreModel searchQueries = context.watch<QueriesStoreModel>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Appbar title'),
      ),
      body: ListView.builder(
        itemCount: searchQueries.items,
        itemBuilder: (context, index) =>
            QueryCardQueryModelProvider(searchQuery: searchQueries.at(index)),
      ),
      floatingActionButton: FloatingActionButton.small(
          key: const Key('add-search-query-button'),
          onPressed: () {
            searchQueries.add('new ${searchQueries.items}');
          },
          child: const Icon(Icons.add_box_rounded)),
    );
  }
}
