import 'package:flutter/foundation.dart';
import 'package:google_search_diff/model/search_results.dart';

class QueryChange extends ChangeNotifier {
  String _query = '';
  String get query => _query;
  void initialQuery(String query) {
    _query = query;
    notifyListeners();
  }
}

class SearchResultsChange extends ChangeNotifier {
  SearchResults _searchResults = NoSearchResults();
  SearchResults get searchResults => _searchResults;
  void inform(SearchResults searchResults) {
    _searchResults = searchResults;
    notifyListeners();
  }
}

class SearchBarController {
  final QueryChange _queryChange = QueryChange();
  final SearchResultsChange _searchResultsChange = SearchResultsChange();

  get query => _queryChange.query;
  void addQueryListener(void Function(String) listener) =>
      _queryChange.addListener(() => listener(_queryChange.query));

  void informResults(SearchResults searchResults) =>
      _searchResultsChange.inform(searchResults);

  void initialQuery(String query) => _queryChange.initialQuery(query);

  void addSearchResultsListener(
          void Function(SearchResults results) listener) =>
      _searchResultsChange
          .addListener(() => listener(_searchResultsChange.searchResults));
}
