import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/actions/actions.dart';
import 'package:google_search_diff/actions/intents.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
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

    widget.searchBarController.addOnErrorListener((error) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                alignment: Alignment.topCenter,
                title: const Text('Error while searching'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Dismiss'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
        actions: {
          ClearIntent:
              ClearAction(widget.searchBarController.searchFieldController),
          QueryIntent: QueryAction(widget.searchBarController)
        },
        child: Expanded(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              title: SearchBarWidget(
                retriever: widget.queryRetriever,
                searchBarController: widget.searchBarController,
              ),
              pinned: true,
              actions: [
                IconButton(
                  key: const Key('do-search-button'),
                  icon: const Icon(
                    Icons.search,
                  ),
                  tooltip: 'Perform google search with query',
                  onPressed: () {
                    QueryAction(widget.searchBarController)
                        .invoke(const QueryIntent());
                  },
                ),
                MenuAnchor(
                  menuChildren: List<MenuItemButton>.generate(
                      SearchResultsStatus.values.length,
                      (index) => MenuItemButton(
                            child: ListTile(
                              leading: Icon(
                                SearchResultsStatus.values[index].icon,
                                color: SearchResultsStatus
                                    .values[index].color[400],
                              ),
                              title:
                                  Text(SearchResultsStatus.values[index].name),
                              onTap: () {},
                              selected: true,
                            ),
                          )),
                  builder: (context, controller, child) => IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                    ),
                    tooltip: 'Choose display filter',
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                  ),
                )
              ],
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
        ));
  }
}

class SearchResultsFilterChip extends StatelessWidget {
  final SearchResultsStatus searchResultsStatus;
  final BorderRadius borderRadius;

  const SearchResultsFilterChip({
    super.key,
    required this.searchResultsStatus,
    required this.borderRadius,
  });

  static left(SearchResultsStatus searchResultsStatus) {
    return SearchResultsFilterChip(
        searchResultsStatus: searchResultsStatus,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)));
  }

  static middle(SearchResultsStatus searchResultsStatus) {
    return SearchResultsFilterChip(
        searchResultsStatus: searchResultsStatus,
        borderRadius: const BorderRadius.all(Radius.zero));
  }

  static right(SearchResultsStatus searchResultsStatus) {
    return SearchResultsFilterChip(
        searchResultsStatus: searchResultsStatus,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)));
  }

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(searchResultsStatus.name),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      selected: true,
      showCheckmark: false,
      avatar: Icon(
        searchResultsStatus.icon,
        color: searchResultsStatus.color[900],
      ),
    );
  }
}
