import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';

abstract class SearchService {
  Future<RunModel> doSearch(Query query);
}

class LoremIpsumSearchService extends SearchService {
  @override
  Future<RunModel> doSearch(Query query) async {
    return Future.delayed(Durations.extralong3).then((value) => RunModel(
        query,
        List.generate(
            100, (index) => ResultModel(title: loremIpsum(words: 5)))));
  }
}
