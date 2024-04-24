import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:relative_time/relative_time.dart';

class GoogleSearchAppBar extends StatefulWidget {
  final SearchResultsStore searchResultsStore;
  final SearchResultsController searchResultsController;
  final SearchBarController searchBarController;

  const GoogleSearchAppBar(
      {super.key,
      required this.searchResultsStore,
      required this.searchResultsController,
      required this.searchBarController});

  @override
  State<StatefulWidget> createState() {
    return _GoogleSearchAppBarState();
  }
}

class _GoogleSearchAppBarState extends State<GoogleSearchAppBar> {
  final logger = FimberLog('appbar');
  @override
  Widget build(BuildContext context) {
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
                      isLabelVisible: widget.searchResultsStore.count() > 0,
                      key: const Key('saved-searches-badge'),
                      label: Text(widget.searchResultsStore.count().toString()),
                      child: PopupMenuButton(
                          onSelected: (String value) {
                            logger.d('selected $value');
                            var result =
                                widget.searchResultsStore.getByUuid(value);
                            widget.searchResultsController
                                .informNewResults(result);
                            widget.searchBarController
                                .initialQuery(result.query);
                          },
                          icon: const Icon(Icons.favorite_border),
                          itemBuilder: (BuildContext context) => widget
                              .searchResultsStore
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
