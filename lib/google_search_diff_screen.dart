import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

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

  final SearchBarController _controller = SearchBarController();

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

    _controller.addSearchResultsListener((results) {
      logger.d('Got new search results: $results');
      setState(() {
        currentSearchResults = results;
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
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  SearchBarWidget(
                                    searchBarController: _controller,
                                  ),
                                ],
                              );
                            }, childCount: 1),
                          ),
                        ];
                      },
                      body: Container(
                        color: GoogleSearchDiffScreenTheme.buildLightTheme()
                            .colorScheme
                            .background,
                        child: ListView.builder(
                          itemCount: currentSearchResults.count(),
                          padding: const EdgeInsets.only(top: 8),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) =>
                              SearchResultListTile(
                                  searchResult: currentSearchResults[index]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu),
            fabSize: ExpandableFabSize.small,
          ),
          distance: 50,
          children: [
            Visibility(
                visible: currentSearchResults.count() > 0 &&
                    !storedSearchResults.has(currentSearchResults),
                child: FloatingActionButton.small(
                    onPressed: () {
                      if (kDebugMode) {
                        logger.d('saving $currentSearchResults');
                      }
                      currentSearchResults.save();
                    },
                    child: const Icon(Icons.save))),
            Visibility(
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
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
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
                      label: Text(storedSearchResults.count().toString()),
                      child: PopupMenuButton(
                          onSelected: (String value) {
                            logger.d('selected $value');
                            setState(() {
                              var result = storedSearchResults.getByUuid(value);
                              currentSearchResults = result;
                              _controller.initialQuery(result.query);
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
