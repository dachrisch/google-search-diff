import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/actions/actions.dart';
import 'package:google_search_diff/actions/intents.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:google_search_diff/view/search_bar_textfield.dart';

class SearchBarAppBar extends StatefulWidget {
  final SearchBarController searchBarController;
  final SearchResultsController searchResultsController;
  final QueryRetriever queryRetriever;

  const SearchBarAppBar({
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

class _SearchBarWidgetView extends State<SearchBarAppBar> {
  final logger = FimberLog('searchbar');

  @override
  void initState() {

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
      child: AppBar(
          automaticallyImplyLeading: false,
          title: SearchBarTextField(
            retriever: widget.queryRetriever,
            searchBarController: widget.searchBarController,
          ),
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
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => showBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                        height: 60,
                        child: Column(children: [
                          SegmentedButton(
                            segments: const <ButtonSegment>[
                              ButtonSegment(
                                  value: 1,
                                  icon: Icon(Icons.add),
                                  label: Text('XS')),
                              ButtonSegment(value: 2, label: Text('S')),
                              ButtonSegment(value: 3, label: Text('M')),
                            ],
                            emptySelectionAllowed: true,
                            multiSelectionEnabled: true,
                            selected: {},
                          )
                        ]));
                  }),
            )
          ]),
    );
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
