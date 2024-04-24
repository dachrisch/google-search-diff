import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_search_diff/service/searches_store.dart';
import 'package:uuid/uuid.dart';

class SearchResult {
  final String title;
  final String source;
  final String link;
  final SearchResultsStatus status;
  final String snippet;

  SearchResult(
      {required this.title,
      required this.source,
      required this.link,
      SearchResultsStatus? status,
      String? snippet})
      : snippet = (snippet == null || snippet.isEmpty) ? title : snippet,
        status = status ?? SearchResultsStatus.added;

  Map<String, dynamic> toJson() =>
      {'title': title, 'source': source, 'link': link, 'snippet': snippet};

  static fromMap(result) {
    return SearchResult(
        title: result['title'],
        source: result['source'],
        link: result['link'],
        status: SearchResultsStatus.existing,
        snippet: result['snippet']);
  }

  bool isSame(SearchResult other) => other.title == title && other.link == link;
  
}

class NoSearchResults extends SearchResults {
  NoSearchResults() : super(query: '', timestamp: DateTime(1970));

  @override
  count() {
    return 0;
  }

  @override
  Map<String, dynamic> toJson({bool onlyNew = true}) {
    return {};
  }
}

enum SearchResultsStatus {
  existing('Existing', Icons.compare_arrows_outlined, Colors.grey),
  removed('Removed', Icons.keyboard_double_arrow_left_outlined, Colors.red),
  added('Added', Icons.keyboard_double_arrow_right_outlined, Colors.green);

  final String name;
  final IconData icon;
  final MaterialColor color;
  const  SearchResultsStatus(this.name, this.icon, this.color);
}

typedef SearchResultsMapType = Map<String, dynamic>;

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

  SearchResultsMapType toJson() => {
        'query': query,
        'timestamp': timestamp.toIso8601String(),
        'results': _results.map((r) => r.toJson()).toList(),
        'id': id
      };

  static SearchResults fromMap(SearchResultsMapType search) {
    var searchResults = SearchResults(
        query: search['query'],
        timestamp: DateTime.parse(search['timestamp']),
        id: search['id']);
    search['results']
        .forEach((r) => searchResults.add(SearchResult.fromMap(r)));
    return searchResults;
  }

  SearchResults compareto(SearchResults previousSearchResults) {
    var searchResults =
        SearchResults(query: query, timestamp: timestamp, id: id);
    for (var result in _results) {
      var status = previousSearchResults.has(result)
          ? SearchResultsStatus.existing
          : SearchResultsStatus.added;
      searchResults.add(SearchResult(
          title: result.title,
          source: result.source,
          link: result.link,
          snippet: result.snippet,
          status: status));
    }
    for (var previous in previousSearchResults._results) {
      if (!searchResults.has(previous)) {
        searchResults.add(SearchResult(
            title: previous.title,
            source: previous.source,
            link: previous.link,
            snippet: previous.snippet,
            status: SearchResultsStatus.removed));
      }
    }
    return searchResults;
  }

  has(SearchResult result) => _results.any((element) => result.isSame(element));

  SearchResults filter(List<SearchResultsStatus> filterList) {
    var searchResults =
        SearchResults(query: query, timestamp: timestamp, id: id);
    _results
        .where((element) => filterList.contains(element.status))
        .forEach((element) => searchResults.add(element));
    return searchResults;
  }

  SearchResults remove(SearchResult searchResult) {
    var searchResults = SearchResults(query: query, timestamp: timestamp);
    _results
        .where((element) => !searchResult.isSame(element))
        .forEach((element) => searchResults.add(element));
    return searchResults;
  }
}

class SearchResultsStore {
  final Set<SearchResults> _searchResults = HashSet<SearchResults>(
    hashCode: (p0) => p0.id.hashCode,
    equals: (p0, p1) => p0.id.compareTo(p1.id) == 0,
  );

  void addFromMap(SearchResultsMapType map) {
    _searchResults.add(SearchResults.fromMap(map));
  }

  int count() => _searchResults.length;

  SearchResults getByUuid(String uuid) =>
      _searchResults.firstWhere((element) => element.id == uuid);

  Iterable<T> map<T>(T Function(SearchResults e) toElement) =>
      _searchResults.map(toElement);

  bool has(SearchResults searchResults) =>
      _searchResults.any((element) => element.id == searchResults.id);
}

extension StorableSearchResultsStore on SearchResultsStore {
  void delete(SearchResults currentSearchResults) {
    currentSearchResults.delete();
    _searchResults.remove(currentSearchResults);
  }
}

extension StorableSearchResults on SearchResults {
  Future save() async {
    final SearchesStore searchesStore = SearchesStore();
    return searchesStore.insert(toJson());
  }

  void delete() async {
    final SearchesStore searchesStore = SearchesStore();
    return searchesStore.deleteById(id);
  }
}
