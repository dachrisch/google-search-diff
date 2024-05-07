import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

abstract class QueryRetriever {
  Future<List<SearchResult>> query(String query);
}

class SerapiRetriever implements QueryRetriever {
  final Logger l = getLogger('serapi');
  final String endpoint = 'serpapi.com';
  final String path = 'search';
  final String apiKey;

  final Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,OPTIONS',
    'Access-Control-Allow-Headers': 'X-Requested-With'
  };

  SerapiRetriever({required this.apiKey});

  @override
  Future<List<SearchResult>> query(String query) async {
    Map<String, dynamic>? queryParameter = {
      'api_key': apiKey,
      'engine': 'google',
      'gl': 'de',
      'hl': 'de',
      'location': 'Germany',
      'num': '200',
      'output': 'json',
      'q': query
    };
    var uri = Uri.https(endpoint, path, queryParameter);
    l.d('Performing search: $uri');
    return http.get(uri, headers: headers).then((response) {
      l.d('Got response: ${response.body}');
      assert(response.statusCode == 200, response.statusCode);
      return jsonDecode(response.body);
    }).then((json) {
      List<SearchResult> sr = [];
      for (var item in json['organic_results']) {
        sr.add(SearchResult(
            title: item['title'],
            link: item['link'],
            source: item['source'],
            snippet: item['snippet']));
      }
      return sr;
    });
  }
}

class SearchProvider {
  final QueryRetriever queryRetriever;

  SearchProvider(this.queryRetriever);

  Future<SearchResults> doSearch(String query) async =>
      queryRetriever.query(query).then((searchResultsList) {
        var searchResults =
            SearchResults(query: query, timestamp: DateTime.now());
        for (var element in searchResultsList) {
          searchResults.add(element);
        }
        return searchResults;
      });
}

class StaticRetriever implements QueryRetriever {
  @override
  Future<List<SearchResult>> query(String query) {
    return Future.delayed(
        Durations.long1,
        () => [
              SearchResult(
                  title: 'Agile Coach Jobs und Stellenangebote - 2024',
                  source: 'Stepstone',
                  link: 'https://www.stepstone.de/jobs/agile-coach',
                  snippet:
                      '... Systeme mbH · Scrum Master (m/w/d) / Agile Coach (m/w/d). GWS Gesellschaft für Warenwirtschafts-Systeme mbH. Münster. Teilweise Home-Office. Gehalt anzeigen.'),
              SearchResult(
                  title: 'Result 2',
                  source: 'Other Test',
                  link: 'http://example-other.com'),
              SearchResult(
                  title: 'Result $query',
                  source: loremIpsum(words: 2),
                  snippet: loremIpsum(words: 60),
                  link: 'http://example-other.com')
            ]);
  }
}

class PerformingSearchError implements Exception {
  final String message;

  PerformingSearchError(this.message);

 @override
  String toString() {
    return '${runtimeType.toString()}: $message';

  }
}
