import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/routes/queryId.dart';

class SearchQueriesStore extends ChangeNotifier {
  final List<SearchQueryModel> searchQueries = [];

  int get items => searchQueries.length;

  void add(String query) {
    searchQueries.add(SearchQueryModel(query));
    notifyListeners();
  }

  void remove(SearchQueryModel searchQuery) {
    searchQueries.remove(searchQuery);
    notifyListeners();
  }

  SearchQueryModel at(int index) => searchQueries[index];

  SearchQueryModel findById(QueryId queryId) =>
      searchQueries.firstWhere((element) => element.queryId == queryId);
}
