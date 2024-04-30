import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/searchQueryStore.dart';
import 'package:google_search_diff/_new/provider/singeQueryModelProvider.dart';
import 'package:provider/provider.dart';

class AllQueriesScaffold extends StatelessWidget {
  const AllQueriesScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    SearchQueriesStore searchQueries = context.watch<SearchQueriesStore>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Appbar title'),
      ),
      body: ListView.builder(
        itemCount: searchQueries.items,
        itemBuilder: (context, index) =>
            SingleQueryModelProvider(searchQuery: searchQueries.at(index)),
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
