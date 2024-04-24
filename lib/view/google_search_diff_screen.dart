import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:google_search_diff/service/searches_store.dart';
import 'package:google_search_diff/view/search_bar_widget.dart';
import 'package:google_search_diff/view/search_results_view.dart';
import 'package:relative_time/relative_time.dart';

class GoogleSearchDiffScreen extends StatefulWidget {
  final QueryRetriever retriever;

  const GoogleSearchDiffScreen({super.key, required this.retriever});

  @override
  State<GoogleSearchDiffScreen> createState() => _GoogleSearchDiffScreenState();
}

class _GoogleSearchDiffScreenState extends State<GoogleSearchDiffScreen> {
  SearchResultsStore storedSearchResults = SearchResultsStore();
  final SearchResultsController searchResultsController =
      SearchResultsController();
  bool isSearching = false;

  final SearchesStore searchesStore = SearchesStore();

  final SearchBarController _searchBarController = SearchBarController();

  final logger = FimberLog('screen');

  @override
  void initState() {
    searchesStore.findAll().then((allSearches) {
      setState(() {
        allSearches?.entries
            .forEach((search) => storedSearchResults.addFromMap(search.value));
      });
    });
    searchesStore.listen((event) {
      setState(() {
        storedSearchResults.addFromMap(event);
      });
    });

    _searchBarController.addSearchResultsListener((results) {
      logger.d('Got new search results: ${results.toJson()}');
      setState(() {
        searchResultsController.compareTo(results);
      });
    });

    _searchBarController.addSearchListener((isSearching) {
      logger.d(isSearching ? 'Started search' : 'Search finished');
      setState(() {
        this.isSearching = isSearching;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    searchesStore.cancelSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GoogleSearchDiffScreenTheme.buildLightTheme(),
      child: Scaffold(
          body: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                    flexibleSpace: SearchBarWidget(
                      retriever: widget.retriever,
                      searchBarController: _searchBarController,
                    ),
                  ),
                  SliverFillRemaining(
                      child: Container(
                    color: GoogleSearchDiffScreenTheme.buildLightTheme()
                        .colorScheme
                        .background,
                    child: isSearching
                        ? const Center(child: CircularProgressIndicator())
                        : SearchResultsView(
                            controller: searchResultsController,
                          ),
                  ))
                ]),
              )
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                    key: const Key('save-search-button'),
                    visible: searchResultsController.itemCount() > 0 &&
                        !storedSearchResults
                            .has(searchResultsController.searchResults),
                    child: FloatingActionButton.small(
                        onPressed: () {
                          if (kDebugMode) {
                            logger.d(
                                'saving ${searchResultsController.searchResults}');
                          }
                          setState(() => searchResultsController.storeNew());
                        },
                        child: const Icon(Icons.save))),
                Visibility(
                    key: const Key('delete-search-button'),
                    visible: storedSearchResults
                        .has(searchResultsController.searchResults),
                    child: FloatingActionButton.small(
                        onPressed: () {
                          if (kDebugMode) {
                            logger.d(
                                'deleting ${searchResultsController.searchResults}');
                          }
                          setState(() {
                            storedSearchResults
                                .delete(searchResultsController.searchResults);
                            storedSearchResults = storedSearchResults;
                          });
                          setState(() => searchResultsController.clear());
                        },
                        child: const Icon(Icons.delete)))
              ],
            ),
          )),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: GoogleSearchDiffScreenTheme.buildLightTheme()
            .colorScheme
            .background,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Center(
                child: Text(
                  'Google Search Diff',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Badge(
                      isLabelVisible: storedSearchResults.count() > 0,
                      key: const Key('saved-searches-badge'),
                      label: Text(storedSearchResults.count().toString()),
                      child: PopupMenuButton(
                          onSelected: (String value) {
                            logger.d('selected $value');
                            setState(() {
                              var result = storedSearchResults.getByUuid(value);
                              searchResultsController.informNewResults(result);
                              _searchBarController.initialQuery(result.query);
                            });
                          },
                          icon: const Icon(Icons.favorite_border),
                          itemBuilder: (BuildContext context) => storedSearchResults
                              .map((stored) => PopupMenuItem(
                                  value: stored.id,
                                  child: Text(
                                      '${RelativeTime(context).format(stored.timestamp)} - ${stored.query} (${stored.count()})')))
                              .toList())),
                  const SizedBox(width: 8),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
