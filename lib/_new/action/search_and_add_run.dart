import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/intent/search.dart';
import 'package:google_search_diff/_new/service/search_service.dart';

class SearchAndAddRunAction extends Action<SearchIntent> {
  final SearchService searchService;

  SearchAndAddRunAction({required this.searchService});

  @override
  Object? invoke(SearchIntent intent) => searchService
      .doSearch(intent.queryRuns.query)
      .then((run) => intent.queryRuns.addRun(run));
}
