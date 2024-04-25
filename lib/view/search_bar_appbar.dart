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
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const SearchResultFilterView();
                  }),
            )
          ]),
    );
  }
}

class SearchResultFilterView extends StatefulWidget {
  const SearchResultFilterView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SearchResultFilterViewState();
}

class _SearchResultFilterViewState extends State<SearchResultFilterView> {
  Set<SearchResultsStatus> selected = SearchResultsStatus.values.toSet();

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
        child: Wrap(children: [
          ListTile(
              title: const Center(child: Text('Results filter')),
              subtitle: SegmentedButton<SearchResultsStatus>(
                segments: <ButtonSegment<SearchResultsStatus>>[
                  SearchResultsStatusButtonSegment(SearchResultsStatus.added),
                  SearchResultsStatusButtonSegment(
                      SearchResultsStatus.existing),
                  SearchResultsStatusButtonSegment(SearchResultsStatus.removed),
                ],
                emptySelectionAllowed: true,
                multiSelectionEnabled: true,
                showSelectedIcon: false,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selected = newSelection;
                  });
                },
                selected: selected,
              )),
          ListTile(
            title: ElevatedButton(
              onPressed: () {},
              child: Text('Filter'),
            ),
          )
        ]));
  }
}

class SearchResultsStatusButtonSegment
    extends ButtonSegment<SearchResultsStatus> {
  SearchResultsStatusButtonSegment(SearchResultsStatus s)
      : super(
            value: s,
            icon: Icon(
              s.icon,
              color: s.color,
            ),
            label: Text(s.name));
}
