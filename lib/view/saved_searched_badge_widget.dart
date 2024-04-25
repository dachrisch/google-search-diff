import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/controller/search_results_controller.dart';
import 'package:google_search_diff/model/search_results.dart';

class SavedSearchedBadgeWidget extends StatelessWidget {
  final FimberLog logger = FimberLog('badge');
  SavedSearchedBadgeWidget({
    super.key,
    required this.searchResultsController,
    required this.searchResultsStore,
  });

  final SearchResultsController searchResultsController;
  final SearchResultsStore searchResultsStore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
            key: const Key('save-search-button'),
            visible: searchResultsController.itemCount() > 0 &&
                !searchResultsStore.has(searchResultsController.searchResults),
            child: FloatingActionButton.small(

                onPressed: () {
                  if (kDebugMode) {
                    logger.d('saving ${searchResultsController.searchResults}');
                  }
                  searchResultsController.storeNew();
                },
                child: const Icon(Icons.save))),
        Visibility(
            key: const Key('delete-search-button'),
            visible:
                searchResultsStore.has(searchResultsController.searchResults),
            child: FloatingActionButton.small(
                onPressed: () {
                  if (kDebugMode) {
                    logger
                        .d('deleting ${searchResultsController.searchResults}');
                  }
                  searchResultsStore
                      .delete(searchResultsController.searchResults);
                  searchResultsController.clear();
                },
                child: const Icon(Icons.delete)))
      ],
    );
  }
}
