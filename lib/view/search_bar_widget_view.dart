import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:google_search_diff/view/search_bar_widget.dart';
import 'package:google_search_diff/view/search_results_view.dart';

class SearchBarWidgetView extends StatefulWidget {
  final SearchBarController searchBarController;
  final SearchResultsController searchResultsController;
  final QueryRetriever queryRetriever;

  const SearchBarWidgetView({
    super.key,
    required this.searchBarController,
    required this.searchResultsController,
    required this.queryRetriever,
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchBarWidgetView();
  }
}

class _SearchBarWidgetView extends State<SearchBarWidgetView> {
  bool isSearching = false;
  final logger = FimberLog('searchbar');

  @override
  void initState() {
    widget.searchBarController.addSearchListener((isSearching) {
      logger.d(isSearching ? 'Started search' : 'Search finished');
      setState(() {
        this.isSearching = isSearching;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(slivers: [
        SliverAppBar(
          actions: [
            IconButton(
              key: const Key('do-search-button'),
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {
                widget.searchBarController.doSearch();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.filter_list,
              ),
              onPressed: () {},
            )
          ],
          flexibleSpace: SearchBarWidget(
            retriever: widget.queryRetriever,
            searchBarController: widget.searchBarController,
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
                  controller: widget.searchResultsController,
                ),
        ))
      ]),
    );
  }
}
