import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/model/searchQueryStore.dart';
import 'package:google_search_diff/_new/routes/routes.dart';
import 'package:provider/provider.dart';

class SingleQueryPageProvider extends StatelessWidget {
  const SingleQueryPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    SearchQueryModel searchQuery =
        context.select<SearchQueriesStore, SearchQueryModel>(
            (store) => store.findById(queryId));

    return ChangeNotifierProvider.value(
        value: searchQuery, child: const SingleQueryPage());
  }
}

class SingleQueryPage extends StatelessWidget {
  const SingleQueryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchQuery = context.watch<SearchQueryModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(searchQuery.query),
      ),
      body: ListView.builder(
          itemCount: searchQuery.results.length,
          itemBuilder: (context, index) =>
              QueryResultView(searchQuery.resultsAt(index))),
      floatingActionButton: FloatingActionButton.small(
          onPressed: () => searchQuery.addResults(QueryResults()),
          child: const Icon(Icons.refresh_outlined)),
    );
  }
}

class QueryResultView extends StatelessWidget {
  final QueryResults queryResults;

  QueryResultView(this.queryResults);

  @override
  Widget build(BuildContext context) {
    var searchQuery = context.watch<SearchQueryModel>();
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
          onTap: () => {},
          child: ListTile(
            title: Text('Created: ${queryResults.queryDate}'),
            subtitle: const Text('sub'),
            trailing: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 1.0, color: Colors.white))),
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => searchQuery.removeResults(queryResults),
                )),
          )),
    );
  }
}
