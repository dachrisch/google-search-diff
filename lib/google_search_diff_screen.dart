import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/search_bar_widget.dart';
import 'package:google_search_diff/search_result_list_tile.dart';
import 'package:localstore/localstore.dart';
import 'package:relative_time/relative_time.dart';

class GoogleSearchDiffScreen extends StatefulWidget {
  const GoogleSearchDiffScreen({super.key});

  @override
  State<GoogleSearchDiffScreen> createState() => _GoogleSearchDiffScreenState();
}

class _GoogleSearchDiffScreenState extends State<GoogleSearchDiffScreen> {
  SearchResults currentSearchResults = NoSearchResults();
  SearchResultsStore storedSearchResults = SearchResultsStore();
  bool isSearching = false;

  final SearchBarController _searchBarController = SearchBarController();

  final _db = Localstore.getInstance(useSupportDir: true);
  final logger = FimberLog('screen');

  @override
  void initState() {
    _db.collection('searches').get().then((allSearches) {
      logger.d('Reading existing searches: $allSearches');
      setState(() {
        allSearches?.entries
            .forEach((search) => storedSearchResults.addFromMap(search.value));
      });
    });
    _db.collection('searches').stream.listen((event) {
      logger.d('New db event: $event');
      setState(() {
        storedSearchResults.addFromMap(event);
      });
    });

    _searchBarController.addSearchResultsListener((results) {
      logger.d('Got new search results: $results');
      setState(() {
        currentSearchResults = results.compareto(currentSearchResults);
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
  Widget build(BuildContext context) {
    return Theme(
      data: GoogleSearchDiffScreenTheme.buildLightTheme(),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  getAppBarUI(),
                  Expanded(
                    child: CustomScrollView(slivers: [
                      SliverAppBar(
                        flexibleSpace: SearchBarWidget(
                          searchBarController: _searchBarController,
                        ),
                      ),
                      SliverFillRemaining(
                          child: Container(
                              color:
                                  GoogleSearchDiffScreenTheme.buildLightTheme()
                                      .colorScheme
                                      .background,
                              child: isSearching
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ListView.builder(
                                      key: const Key('search-results'),
                                      itemCount: currentSearchResults.count(),
                                      padding: const EdgeInsets.only(top: 8),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          SearchResultListTile(
                                              key: Key(
                                                  'search-result-tile-$index'),
                                              doDelete: (searchResult) {
                                                logger.d(
                                                    'Removing $searchResult from list');
                                                setState(() {
                                                  currentSearchResults =
                                                      currentSearchResults
                                                          .remove(searchResult);
                                                });
                                              },
                                              searchResult:
                                                  currentSearchResults[index]),
                                    ),
                          ))
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: const Key('fab-menu'),
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu),
            fabSize: ExpandableFabSize.small,
          ),
          distance: 50,
          children: [
            Visibility(
                key: const Key('save-search-button'),
                visible: currentSearchResults.count() > 0 &&
                    !storedSearchResults.has(currentSearchResults),
                child: FloatingActionButton.small(
                    onPressed: () {
                      if (kDebugMode) {
                        logger.d('saving $currentSearchResults');
                      }
                      setState(() {
                        currentSearchResults = currentSearchResults.filter([
                          SearchResultsStatus.added,
                          SearchResultsStatus.existing
                        ]);
                        currentSearchResults.save();
                      });
                    },
                    child: const Icon(Icons.save))),
            Visibility(
                key: const Key('delete-search-button'),
                visible: storedSearchResults.has(currentSearchResults),
                child: FloatingActionButton.small(
                    onPressed: () {
                      if (kDebugMode) {
                        logger.d('deleting $currentSearchResults');
                      }
                      setState(() {
                        storedSearchResults.delete(currentSearchResults);
                        storedSearchResults = storedSearchResults;
                      });
                      setState(() => currentSearchResults = NoSearchResults());
                    },
                    child: const Icon(Icons.delete)))
          ],
        ),
      ),
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
                      key: const Key('saved-searches-badge'),
                      label: Text(storedSearchResults.count().toString()),
                      child: PopupMenuButton(
                          onSelected: (String value) {
                            logger.d('selected $value');
                            setState(() {
                              var result = storedSearchResults.getByUuid(value);
                              currentSearchResults = result;
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
