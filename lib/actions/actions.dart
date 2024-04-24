import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/actions/intents.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/model/search_results.dart';

class QueryAction extends Action<QueryIntent> {
  final SearchBarController searchBarController;
  final FimberLog logger=FimberLog('query');
  QueryAction(this.searchBarController);

  @override
  Object? invoke(QueryIntent intent) {
    searchBarController.doSearch().onError((error, stackTrace) {
      searchBarController.stopSearch();
      searchBarController.informError(error);
      logger.e('Error while performing search', stacktrace: stackTrace);
      return SearchResults(query: '', timestamp: DateTime.now());
    });
    return null;
  }
}

class ClearAction extends Action<ClearIntent> {
  final TextEditingController searchFieldController;
  ClearAction(this.searchFieldController);

  @override
  Object? invoke(ClearIntent intent) {
    searchFieldController.clear();
    return null;
  }
}
