import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

class SearchProvider {
  final SearchBarController searchBarController;
  SearchProvider(this.searchBarController);

  void doSearch(String text) {
    var searchResults = SearchResults(query: text, timestamp: DateTime.now());
    searchResults.add(SearchResult(
        title: 'Agile Coach Jobs und Stellenangebote - 2024',
        source: 'Stepstone',
        link: 'https://www.stepstone.de/jobs/agile-coach',
        snippet:
            '... Systeme mbH · Scrum Master (m/w/d) / Agile Coach (m/w/d). GWS Gesellschaft für Warenwirtschafts-Systeme mbH. Münster. Teilweise Home-Office. Gehalt anzeigen.'));
    searchResults.add(SearchResult(
        title: 'Result 2',
        source: 'Other Test',
        link: 'http://example-other.com'));
    searchResults.add(SearchResult(
        title: 'Result $text',
        source: loremIpsum(words: 2),
        snippet: loremIpsum(words: 60),
        link: 'http://example-other.com'));

    searchBarController.informResults(searchResults);
  }
}
