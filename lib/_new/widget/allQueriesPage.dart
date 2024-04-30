import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/model/searchQueryStore.dart';
import 'package:google_search_diff/_new/widget/singleQueryView.dart';
import 'package:provider/provider.dart';

class AllQueriesPage extends StatelessWidget {
  const AllQueriesPage({super.key});

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
        itemBuilder: (context, index) => SingleQueryViewProvider(searchQuery:  searchQueries.at(index)),
      ),
      floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            searchQueries.add('new ${searchQueries.items}');
          },
          child: const Icon(Icons.add_box_rounded)),
    );
  }
}

class SingleQueryViewProvider extends StatelessWidget {
  final SearchQueryModel searchQuery;

  const SingleQueryViewProvider({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
        value: searchQuery, child: SingleQueryView());
  }
}
