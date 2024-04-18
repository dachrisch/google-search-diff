import 'dart:collection';

import 'package:fimber/fimber.dart';
import 'package:flutter/src/material/popup_menu.dart';
import 'package:localstore/localstore.dart';
import 'package:uuid/uuid.dart';

class SearchResult {
  final String title;
  final String source;
  final String link;
  final String snippet;

  SearchResult(
      {required this.title,
      required this.source,
      required this.link,
      String? snippet})
      : snippet = (snippet == null || snippet.isEmpty) ? title : snippet;

  Map<String, dynamic> toJson() =>
      {'title': title, 'source': source, 'link': link, 'snippet': snippet};

  static fromMap(result) {
    return SearchResult(
        title: result['title'],
        source: result['source'],
        link: result['link'],
        snippet: result['snippet']);
  }
}

class NoSearchResults extends SearchResults {
  NoSearchResults() : super(query: '', timestamp: DateTime(1970));

  @override
  count() {
    return 0;
  }

  @override
  Map<String, dynamic> toJson() {
    throw StateError("No Search Result - can't create json");
  }
}

class SearchResults {
  final String query;
  final DateTime timestamp;
  final List<SearchResult> _results = [];
  final String id;

  SearchResults({required this.query, required this.timestamp, String? id})
      : id = id ?? const Uuid().v4();

  count() => _results.length;

  add(SearchResult searchResult) => _results.add(searchResult);

  SearchResult operator [](int index) => _results[index];

  Map<String, dynamic> toJson() => {
        'query': query,
        'timestamp': timestamp.toIso8601String(),
        'results': _results.map((r) => r.toJson()).toList(),
        'id': id
      };

  static SearchResults fromMap(Map<String, dynamic> search) {
    var searchResults = SearchResults(
        query: search['query'], timestamp: DateTime.parse(search['timestamp']));
    search['results']
        .forEach((r) => searchResults.add(SearchResult.fromMap(r)));
    return searchResults;
  }
}

class SearchResultsStore {
  final Set<SearchResults> _searchResults=HashSet<SearchResults>();

  void addFromMap(Map<String,dynamic> map) {
    _searchResults.add(SearchResults.fromMap(map));
  }

  int count() => _searchResults.length;

  SearchResults getByUuid(String uuid) => _searchResults.firstWhere((element) => element.id==uuid);

  Iterable<T> map<T>(T Function(SearchResults e) toElement) => _searchResults.map(toElement);

}

extension StorableSearchResults on SearchResults {
  Future save() async {
    final logger = FimberLog('store');
    final db = Localstore.instance;
    final id = db.collection('searches').doc().id;
    var json = toJson();
    logger.d('Storing $this with [$id]: $json');
    return db.collection('searches').doc(id).set(json);
  }
}
