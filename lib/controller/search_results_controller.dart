import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:logger/logger.dart';

class SearchResultsController {
  final SearchResultsChange _searchResultsChange = SearchResultsChange();

  SearchResults searchResults = NoSearchResults();
  final Logger logger = getLogger('controller');

  int itemCount() => searchResults.count();

  void removeResult(searchResult) {
    searchResults = searchResults.remove(searchResult);
    _searchResultsChange.inform(searchResults);
  }

  resultAt(int index) => searchResults[index];

  void compareTo(SearchResults results) {
    var sr = results.compareto(searchResults);
    logger.d(
        'Comparing ${results.toJson()} to ${searchResults.toJson()}: ${sr.toJson()}');
    searchResults = sr;
    _searchResultsChange.inform(searchResults);
  }

  void informNewResults(SearchResults result) {
    searchResults = result;
    _searchResultsChange.inform(searchResults);
  }

  void storeNew() {
    searchResults = searchResults
        .filter([SearchResultsStatus.added, SearchResultsStatus.existing]);
    searchResults.save();
    _searchResultsChange.inform(searchResults);
  }

  void clear() {
    searchResults = NoSearchResults();
    _searchResultsChange.inform(searchResults);
  }

    void addSearchResultsListener(
          void Function(SearchResults results) listener) =>
      _searchResultsChange
          .addListener(() => listener(_searchResultsChange.searchResults));

}
