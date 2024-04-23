import 'package:google_search_diff/model/search_results.dart';

class SearchResultsController {
  SearchResults searchResults = NoSearchResults();

  int itemCount() => searchResults.count();

  void removeResult(searchResult) =>
      searchResults = searchResults.remove(searchResult);

  resultAt(int index) => searchResults[index];

  void compareTo(SearchResults results) =>
      searchResults = results.compareto(searchResults);

  void informNewResults(SearchResults result) => searchResults = result;

  void storeNew() {
    searchResults = searchResults
        .filter([SearchResultsStatus.added, SearchResultsStatus.existing]);
    searchResults.save();
  }

  void clear() => searchResults = NoSearchResults();
}
