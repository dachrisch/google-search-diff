import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/view/search_result_list_tile.dart';
import 'package:logger/logger.dart';

class SearchResultsView extends StatefulWidget {
  final SearchResultsController searchResultsController;
  final SearchBarController searchBarController;

  const SearchResultsView(
      {super.key,
      required this.searchResultsController,
      required this.searchBarController});

  @override
  State<StatefulWidget> createState() => _SearchResultsView();
}

class _SearchResultsView extends State<SearchResultsView> {
  final Logger l = getLogger('search-result');

  bool isSearching = false;

  @override
  void initState() {
    widget.searchBarController.addSearchListener((isSearching) {
      l.d(isSearching ? 'Started search' : 'Search finished');
      setState(() {
        this.isSearching = isSearching;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: isSearching
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: GoogleSearchDiffScreenTheme.buildLightTheme()
                    .colorScheme
                    .background,
                child: ListView.builder(
                  key: const Key('search-results'),
                  itemCount: widget.searchResultsController.itemCount(),
                  padding: const EdgeInsets.only(top: 8),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) =>
                      SearchResultListTile(
                          key: Key('search-result-tile-$index'),
                          doDelete: (searchResult) {
                            l.d('Removing $searchResult from list');
                            setState(() {
                              widget.searchResultsController
                                  .removeResult(searchResult);
                            });
                          },
                          searchResult:
                              widget.searchResultsController.resultAt(index)),
                ),
              ));
  }
}
