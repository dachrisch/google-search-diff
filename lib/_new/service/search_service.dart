import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:injectable/injectable.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

abstract class SearchService {
  Future<Run> doSearch(Query query);
}

@Singleton(as: SearchService)
class LoremIpsumSearchService extends SearchService {
  @override
  Future<Run> doSearch(Query query) async {
    return Future.delayed(Durations.extralong3).then((value) => Run(query,
        List.generate(100, (index) => Result(title: loremIpsum(words: 5)))));
  }
}
