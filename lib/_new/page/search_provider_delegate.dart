import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/service/history_service.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:provider/provider.dart';

class SearchProviderSearchDelegate extends SearchDelegate<Query> {
  final SearchService searchProvider;
  final void Function(ResultsModel results) onSave;

  final ScrollController scrollController = ScrollController();

  ResultsModel results = ResultsModel.empty();

  SearchProviderSearchDelegate(
      {required this.searchProvider, required this.onSave})
      : super(searchFieldLabel: 'Search...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          key: const Key('save-query-button'),
          onPressed: () {
            if (query.isEmpty) {
              return;
            } else {
              onSave(results);
            }
          },
          icon: const Icon(Icons.favorite_outline)),
      IconButton(
        key: const Key('clear-search-button'),
        icon: const Icon(Icons.clear_outlined),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) => null,
        itemCount: 0,
      );
    } else {
      context.watch<HistoryService>().addQuery(Query(query));
      return FutureBuilder<List<ResultModel>>(
        future: searchProvider.doSearch(Query(query)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            results = ResultsModel(Query(query), snapshot.data!);
            return ListView.builder(
                itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(snapshot.data![index].title),
                      ),
                    ),
                itemCount: snapshot.data!.length);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var historyService = context.watch<HistoryService>();
    var suggestions = historyService.getMatching(Query(query));

    return Card(
        elevation: 8,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 130),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: suggestions.isEmpty
                ? const Text('No recent searches')
                : const Text('Recent searches'),
          ),
          Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(suggestions[index].query),
                      trailing: IconButton(
                        key: Key('delete-search-$index-button'),
                        icon: const Icon(Icons.clear_outlined),
                        onPressed: () =>
                            historyService.remove(suggestions[index]),
                      ),
                      onTap: () {
                        query = suggestions[index].query;
                        showResults(context);
                      }),
                  itemCount: suggestions.length))
        ]));
  }
}
