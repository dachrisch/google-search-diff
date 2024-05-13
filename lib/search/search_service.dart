import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

abstract class SearchService {
  Future<Run> doSearch(Query query);
}

@Environment(Environment.test)
@Singleton(as: SearchService)
class LoremIpsumSearchService implements SearchService {
  @override
  Future<Run> doSearch(Query query) async {
    return Future.delayed(Durations.extralong3).then((value) => Run(query,
        List.generate(100, (index) => Result(title: loremIpsum(words: 5)))));
  }
}

@Environment(Environment.prod)
@singleton
class ApiKeyService {
  final String key;

  @factoryMethod
  static fromEnvKey() {
    String apiKey = const String.fromEnvironment('GOOGLE_API_KEY');
    if (apiKey.isEmpty) {
      throw ArgumentError('"GOOGLE_API_KEY" not set');
    }
    return ApiKeyService(key: apiKey);
  }

  ApiKeyService({required this.key});
}

@Environment(Environment.prod)
@Singleton(as: SearchService)
class SerapiSearchService implements SearchService {
  final Logger l = getLogger('serapi');
  final String endpoint = 'serpapi.com';
  final String path = 'search';
  final ApiKeyService apiKeyService;

  SerapiSearchService(this.apiKeyService);

  final Map<String, String> headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,OPTIONS',
    'Access-Control-Allow-Headers': 'X-Requested-With'
  };

  @override
  Future<Run> doSearch(Query query) {
    Map<String, String>? queryParameter = {
      'api_key': apiKeyService.key,
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
          throw error as Error;
        });
  }
}
