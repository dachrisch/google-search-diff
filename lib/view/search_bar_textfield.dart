import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/actions/actions.dart';
import 'package:google_search_diff/actions/intents.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:logger/logger.dart';

class SearchBarTextField extends StatelessWidget {
  final SearchBarController searchBarController;
  final QueryRetriever retriever;

  final Logger l = getLogger('search');

  SearchBarTextField(
      {super.key, required this.searchBarController, required this.retriever});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 0, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 0, top: 4, bottom: 4),
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
                  padding: const EdgeInsets.only(left: 16),
                  child: TextField(
                    key: const Key('search-query-field'),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => {
                      QueryAction(searchBarController)
                          .invoke(const QueryIntent())
                    },
                    controller: searchBarController.searchFieldController,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: GoogleSearchDiffScreenTheme.buildLightTheme()
                        .primaryColor,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () => ClearAction(
                                  searchBarController.searchFieldController)
                              .invoke(const ClearIntent()),
                          icon: const Icon(Icons.clear_sharp)),
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
