import 'package:fimber/fimber.dart';
import 'package:google_search_diff/model/search_results.dart';

class SearchResultsController {
  SearchResults searchResults = NoSearchResults();
  final logger = FimberLog('controller');

  int itemCount() => searchResults.count();

  void removeResult(searchResult) =>
      searchResults = searchResults.remove(searchResult);

  resultAt(int index) => searchResults[index];

  void compareTo(SearchResults results) {
    var sr = results.compareto(searchResults);
    logger.d('Comparing ${results.toJson()} to ${searchResults.toJson()}: ${sr.toJson()}');
    searchResults=sr;
  }

  void informNewResults(SearchResults result) => searchResults = result;

  void storeNew() {
    searchResults = searchResults
        .filter([SearchResultsStatus.added, SearchResultsStatus.existing]);
    searchResults.save();
  }

  void clear() => searchResults = NoSearchResults();
}
