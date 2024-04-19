import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_search_diff/controller/query_change.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/service/search_provider.dart';

class SearchBarWidget extends StatefulWidget {
  final SearchBarController searchBarController;

  const SearchBarWidget({super.key, required this.searchBarController});

  @override
  State<StatefulWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final logger = FimberLog('search');
  final TextEditingController searchFieldController = TextEditingController();

  late SearchBarController searchBarController;
  late SearchProvider searchProvider;

  @override
  void initState() {
    super.initState();
    searchBarController = widget.searchBarController;
    searchBarController.addQueryListener((query) {
      logger.d('setting query to: $query');
      searchFieldController.text = query;
    });
    var apiKey = const String.fromEnvironment('GOOGLE_API_KEY');
    QueryRetriever retriever =
        apiKey == "" ? StaticRetriever() : SerapiRetriever(apiKey: apiKey);
    searchProvider = SearchProvider(searchBarController, retriever);
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
                    key: const Key('search-query-field'),
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
              key: const Key('do-search-button'),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (kDebugMode) {
                    logger.d('search for: ${searchFieldController.text}');
                  }
                  searchBarController.startSearch();
                  searchProvider.doSearch(searchFieldController.text);
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
}
