import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:google_search_diff/service/searches_store.dart';
import 'package:google_search_diff/view/google_search_app_bar.dart';
import 'package:google_search_diff/view/saved_searched_badge_widget.dart';
import 'package:google_search_diff/view/search_bar_widget_view.dart';

class GoogleSearchDiffScreen extends StatefulWidget {
  final QueryRetriever queryRetriever;

  const GoogleSearchDiffScreen({super.key, required this.queryRetriever});

  @override
  State<GoogleSearchDiffScreen> createState() => _GoogleSearchDiffScreenState();
}

class _GoogleSearchDiffScreenState extends State<GoogleSearchDiffScreen> {
  final SearchResultsStore searchResultsStore = SearchResultsStore();
  final SearchResultsController searchResultsController =
      SearchResultsController();

  final SearchesStore searchesStore = SearchesStore();

  late SearchBarController searchBarController;

  final logger = FimberLog('screen');

  @override
  void initState() {
    searchBarController = SearchBarController(SearchProvider(widget.queryRetriever));
    searchesStore.findAll().then((allSearches) {
      setState(() {
        allSearches?.entries
            .forEach((search) => searchResultsStore.addFromMap(search.value));
      });
    });
    searchesStore.listen((event) {
      setState(() {
        searchResultsStore.addFromMap(event);
      });
    });

    searchBarController.addSearchResultsListener((results) {
      logger.d('Comparing new search to existing: ${results.toJson()}');
      searchResultsController.compareTo(results);
    });

    searchResultsController.addSearchResultsListener((results) {
      logger.d('Got new search results: ${results.toJson()}');
      setState(() {
        searchResultsController;
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
        appBar: GoogleSearchAppBar(
          searchResultsStore: searchResultsStore,
          searchResultsController: searchResultsController,
          searchBarController: searchBarController,
        ),
          body: Column(
            children: <Widget>[
              SearchBarWidgetView(
                  searchBarController: searchBarController,
                  searchResultsController: searchResultsController,
                  queryRetriever: widget.queryRetriever)
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SavedSearchedBadgeWidget(
                searchResultsController: searchResultsController,
                searchResultsStore: searchResultsStore),
          )),
    );
  }
}
