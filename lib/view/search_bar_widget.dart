import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/service/search_provider.dart';

class SearchBarWidget extends StatefulWidget {
  final SearchBarController searchBarController;

  final QueryRetriever retriever;

  const SearchBarWidget(
      {super.key, required this.searchBarController, required this.retriever});

  @override
  State<StatefulWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final logger = FimberLog('search');

  @override
  void initState() {
    super.initState();
    widget.searchBarController.addQueryListener((query) {
      logger.d('setting query to: $query');
      // TODO: fixme
      widget.searchBarController.searchFieldController.text = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 24, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: GoogleSearchDiffScreenTheme.buildLightTheme()
                      .colorScheme
                      .background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 0, bottom: 0),
                  child: TextField(
                    key: const Key('search-query-field'),
                    controller: widget.searchBarController.searchFieldController,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: GoogleSearchDiffScreenTheme.buildLightTheme()
                        .primaryColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
