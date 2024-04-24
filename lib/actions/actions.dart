import 'package:flutter/material.dart';
import 'package:google_search_diff/actions/intents.dart';
import 'package:google_search_diff/controller/query_change.dart';

class QueryAction extends Action<QueryIntent> {
  final SearchBarController searchBarController;
  QueryAction(this.searchBarController);

  @override
  Object? invoke(QueryIntent intent) {
    searchBarController.doSearch();
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
