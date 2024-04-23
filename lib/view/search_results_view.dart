import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/view/search_result_list_tile.dart';

class SearchResultsView extends StatefulWidget {
  final SearchResultsController controller;

  const SearchResultsView({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _SearchResultsView();
}

class _SearchResultsView extends State<SearchResultsView> {
  final FimberLog logger = FimberLog('search-result');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('search-results'),
      itemCount: widget.controller.itemCount(),
      padding: const EdgeInsets.only(top: 8),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) => SearchResultListTile(
          key: Key('search-result-tile-$index'),
          doDelete: (searchResult) {
            logger.d('Removing $searchResult from list');
            setState(() {
              widget.controller.removeResult(searchResult);
            });
          },
          searchResult: widget.controller.resultAt(index)),
    );
  }
}
