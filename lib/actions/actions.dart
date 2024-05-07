import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/actions/intents.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:logger/logger.dart';

class QueryAction extends Action<QueryIntent> {
  final SearchBarController searchBarController;
  final Logger l=getLogger('query');
  QueryAction(this.searchBarController);

  @override
  Object? invoke(QueryIntent intent) {
    searchBarController.doSearch().onError((error, stackTrace) {
      searchBarController.stopSearch();
      searchBarController.informError(error);
      l.e('Error while performing search', stackTrace: stackTrace);
      return SearchResults(query: '', timestamp: DateTime.now());
    });
    return null;
  }
}

class ClearAction extends Action<ClearIntent> {
  final TextEditingController searchFieldController;
  final Logger logger=getLogger('clear');
  ClearAction(this.searchFieldController);

  @override
  Object? invoke(ClearIntent intent) {
    logger.d('cleared search field');
    searchFieldController.clear();
    return null;
  }
}
