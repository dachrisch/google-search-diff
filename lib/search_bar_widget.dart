import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_search_diff/main.dart';

typedef SearchResultCallback = void Function(SearchResults searchResult);

class Result {
  final String title;
  final String source;
  final String link;
  final String snippet;

  Result(
      {required this.title,
      required this.source,
      required this.link,
      String? snippet})
      : snippet = (snippet == null || snippet.isEmpty) ? title : snippet;
}

class SearchResults {
  final List<Result> result = [];

  count() => result.length;
}

class SearchBarWidget extends StatefulWidget {
  final SearchResultCallback searchCallback;

  const SearchBarWidget({super.key, required this.searchCallback});

  @override
  State<StatefulWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late SearchResultCallback searchCallback;
  String query = '';

  @override
  void initState() {
    super.initState();
    searchCallback = widget.searchCallback;
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
                    onChanged: (String txt) {
                      if (kDebugMode) {
                        print('setting query to: $txt');
                      }
                      setState(() {
                        query = txt;
                      });
                    },
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
                    print('search for: $query');
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
    var searchResults = SearchResults();
    searchResults.result.add(Result(title: 'Result 1', source: 'Test', link: 'http://example.com'));
    searchResults.result.add(Result(title: 'Result 2', source: 'Other Test', link:'http://example-other.com'));
    searchCallback(searchResults);
  }
}
