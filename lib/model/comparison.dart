import 'package:flutter/foundation.dart';
import 'package:google_search_diff/model/run.dart';

import 'result.dart';

class ComparedResult extends Result {
  ComparedResult(Result result)
      : super(
            id: result.id,
            title: result.title,
            snippet: result.snippet,
            source: result.source,
            link: result.link,
            favicon: result.favicon);
}

class AddedResult extends ComparedResult {
  AddedResult(super.result);
}

class ExistingResult extends ComparedResult {
  ExistingResult(super.result);
}

class RemovedResult extends ComparedResult {
  RemovedResult(super.result);
}

class ResultComparison {
  final List<ComparedResult> compared = [];

  ResultComparison(Run base, Run current) {
    for (var result in current.results) {
      if (base.results.contains(result)) {
        compared.add(ExistingResult(result));
      } else {
        compared.add(AddedResult(result));
      }
    }
    for (var result in base.results) {
      if (!current.results.contains(result)) {
        compared.add(RemovedResult(result));
      }
    }
  }

  int  count<T extends ComparedResult>() => compared.whereType<T>().length;

  @override
  bool operator ==(Object other) =>
      other is ResultComparison && listEquals(compared, other.compared);

  @override
  int get hashCode => Object.hashAll(compared);

  @override
  String toString() => 'ResultComparison($compared)';
}
