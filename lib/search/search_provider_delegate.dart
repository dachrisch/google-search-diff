import 'package:flutter/material.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/search/search_result_view.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/service/history_service.dart';
import 'package:provider/provider.dart';

// MAYBE: use https://github.com/darjaorlova/bunny_search_animated_searchbar/
class SearchProviderSearchDelegate extends SearchDelegate<Query> {
  final SearchService searchProvider;
  final Future<void> Function(Run results) onSave;

  final ScrollController scrollController = ScrollController();

  SearchProviderSearchDelegate(
      {required this.searchProvider,
      required this.onSave,
      TextStyle? textStyle})
      : super(
            searchFieldLabel: 'Create search...', searchFieldStyle: textStyle);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super
        .appBarTheme(context)
        .copyWith(appBarTheme: Theme.of(context).appBarTheme);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
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
      context.read<HistoryService>().addQuery(Query(query));
      return FutureBuilder<Run>(
        future: searchProvider.doSearch(Query(query)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SearchResultsView(run: snapshot.data!, onSave: onSave);
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

    return SafeArea(
      child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        title: Text(suggestions[index].term),
                        trailing: IconButton(
                          key: Key('delete-search-$index-button'),
                          icon: const Icon(Icons.clear_outlined),
                          onPressed: () =>
                              historyService.remove(suggestions[index]),
                        ),
                        onTap: () {
                          query = suggestions[index].term;
                          showResults(context);
                        }),
                    itemCount: suggestions.length))
          ])),
    );
  }
}
