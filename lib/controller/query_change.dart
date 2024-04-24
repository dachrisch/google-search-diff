import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/service/search_provider.dart';

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

class SearchChange extends ChangeNotifier {
  bool _isSearching = false;

  bool get isSearching => _isSearching;

  void informSearch(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }
}

class SearchBarController {
  final QueryChange _queryChange = QueryChange();
  final SearchResultsChange _searchResultsChange = SearchResultsChange();
  final SearchChange _searchChange = SearchChange();
  final TextEditingController searchFieldController = TextEditingController();
  final FimberLog logger = FimberLog('searchbar-controller');
  final ErrorChange errorChange = ErrorChange();

  final SearchProvider searchProvider;

  SearchBarController(this.searchProvider) {
    addQueryListener((query) {
      logger.d('setting query to: $query');
      searchFieldController.text = query;
    });
  }

  String get query => _queryChange.query;

  void initialQuery(String query) => _queryChange.initialQuery(query);

  void addQueryListener(void Function(String) listener) =>
      _queryChange.addListener(() => listener(_queryChange.query));

  void informResults(SearchResults searchResults) =>
      _searchResultsChange.inform(searchResults);

  void addSearchResultsListener(
          void Function(SearchResults results) listener) =>
      _searchResultsChange
          .addListener(() => listener(_searchResultsChange.searchResults));

  void startSearch() => _searchChange.informSearch(true);

  void stopSearch() => _searchChange.informSearch(false);

  bool get isSearching => _searchChange.isSearching;

  void addSearchListener(void Function(bool isSearching) listener) {
    _searchChange.addListener(() => listener(_searchChange.isSearching));
  }

  Future<SearchResults> doSearch() {
    startSearch();
    logger.d('search for: ${searchFieldController.text}');
    return searchProvider
        .doSearch(searchFieldController.text)
        .then((searchResults) {
      informResults(searchResults);
      stopSearch();
      return searchResults;
    });
  }

  void informError(Object? error) => errorChange.informError(error);
  void addOnErrorListener(void Function(Object? error) listener) {
    errorChange.addListener(() => listener(errorChange.error));
  }
}

class ErrorChange extends ChangeNotifier {
  Object? error;

  informError(Object? error) {
    this.error = error;
    notifyListeners();
  }
}
