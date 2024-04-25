import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:relative_time/relative_time.dart';

class GoogleSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final SearchResultsStore searchResultsStore;
  final SearchResultsController searchResultsController;
  final SearchBarController searchBarController;

  @override
  final Size preferredSize;

  const GoogleSearchAppBar(
      {super.key,
      required this.searchResultsStore,
      required this.searchResultsController,
      required this.searchBarController})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() {
    return _GoogleSearchAppBarState();
  }
}

class _GoogleSearchAppBarState extends State<GoogleSearchAppBar> {
  final logger = FimberLog('appbar');

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
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
                  MenuAnchor(
                      menuChildren: widget.searchResultsStore
                          .map((stored) => MenuItemButton(
                              onPressed: () {
                                logger.d('selected $stored');
                                widget.searchResultsController
                                    .informNewResults(stored);
                                widget.searchBarController
                                    .initialQuery(stored.query);
                              },
                              child: Text(
                                  '${RelativeTime(context).format(stored.timestamp)} - ${stored.query} (${stored.count()})')))
                          .toList(),
                      builder: (context, controller, child) => Badge(
                          isLabelVisible: widget.searchResultsStore.count() > 0,
                          key: const Key('saved-searches-badge'),
                          label: Text(
                              widget.searchResultsStore.count().toString()),
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite_border,
                            ),
                            tooltip: 'Select saved search',
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                          ))),
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
