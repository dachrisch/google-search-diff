import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/search/api_key_service.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';



abstract class SearchService {
  Future<Run> doSearch(Query query);
}

@singleton
class LoremIpsumSearchService implements SearchService {
  @override
  Future<Run> doSearch(Query query) async {
    return Future.delayed(Durations.extralong3).then((value) => Run(query,
        List.generate(100, (index) => Result(title: loremIpsum(words: 5)))));
  }
}


@singleton
class SerpApiSearchService implements SearchService {
  final Logger l = getLogger('serp-api');
  final String endpoint = 'serpapi.com';
  final String path = 'search';
  final ApiKeyService apiKeyService;

  SerpApiSearchService(this.apiKeyService);

  final Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,OPTIONS',
    'Access-Control-Allow-Headers': 'X-Requested-With'
  };

  @override
  Future<Run> doSearch(Query query) {
    Map<String, String>? queryParameter = {
      'api_key': apiKeyService.apiKey.key,
      'engine': 'google',
      'gl': 'de',
      'hl': 'de',
      'location': 'Germany',
      'num': '200',
      'output': 'json',
      'q': query.term
    };
    var uri = Uri.https(endpoint, path, queryParameter);
    l.d('Performing search: $uri');
    return http
        .get(uri, headers: headers)
        .then((response) {
          l.d('Got response: ${response.statusCode}');
          assert(response.statusCode == 200, response.statusCode);
          return jsonDecode(response.body);
        })
        .then((json) => Run(
            query,
            (json['organic_results'] as List<dynamic>)
                .map((item) => Result(
                    title: item['title'],
                    link: item['link'],
                    source: item['source'],
                    snippet: item['snippet'],
                    favicon: item['favicon']))
                .toList()))
        .onError((error, stackTrace) {
          l.e('Failed to $query', error: error, stackTrace: stackTrace);
          throw Exception(error);
        });
  }
}
