import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';

typedef SearchResultCallback = void Function(SearchResults searchResult);

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

class SearchBarWidget extends StatefulWidget {
  final SearchBarController searchBarController;

  const SearchBarWidget(
      {super.key,
      required this.searchBarController});

  @override
  State<StatefulWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final logger = FimberLog('search');
  late SearchBarController searchBarController;

  final TextEditingController searchFieldController = TextEditingController();

  _SearchBarWidgetState();

  @override
  void initState() {
    super.initState();
    searchBarController = widget.searchBarController;
    searchBarController.addQueryListener((query) {
      logger.d('setting query to: $query');
      searchFieldController.text = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: GoogleSearchDiffScreenTheme.buildLightTheme()
                      .colorScheme
                      .background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    controller: searchFieldController,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: GoogleSearchDiffScreenTheme.buildLightTheme()
                        .primaryColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: GoogleSearchDiffScreenTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (kDebugMode) {
                    logger.d('search for: ${searchFieldController.text}');
                    _doSearch();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.magnifyingGlass,
                      size: 20,
                      color: GoogleSearchDiffScreenTheme.buildLightTheme()
                          .colorScheme
                          .background),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _doSearch() {
    var searchResults = SearchResults(
        query: searchFieldController.text, timestamp: DateTime.now());
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
    searchBarController.informResults(searchResults);
  }
}
