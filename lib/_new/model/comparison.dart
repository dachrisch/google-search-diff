import 'package:flutter/foundation.dart';

import 'result.dart';

class ResultComparison {
  final List<ResultModel> added = [];
  final List<ResultModel> existing = [];
  final List<ResultModel> removed = [];

  ResultComparison(
      {List<ResultModel>? added,
      List<ResultModel>? existing,
      List<ResultModel>? removed}) {
    this.added.addAll(added ?? []);
    this.existing.addAll(existing ?? []);
    this.removed.addAll(removed ?? []);
  }

  @override
  bool operator ==(Object other) =>
      other is ResultComparison &&
      listEquals(added, other.added) &&
      listEquals(existing, other.existing) &&
      listEquals(removed, other.removed);

  @override
  int get hashCode => Object.hash(
      Object.hashAll(added), Object.hashAll(existing), Object.hashAll(removed));

  @override
  String toString() =>
      'ResultComparison(added: $added, existing: $existing, removed: $removed)';
}
