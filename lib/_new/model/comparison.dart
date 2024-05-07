import 'package:flutter/foundation.dart';

import 'result.dart';

class ResultComparison {
  final List<Result> added = [];
  final List<Result> existing = [];
  final List<Result> removed = [];

  ResultComparison({List<Result>? added,
    List<Result>? existing,
    List<Result>? removed}) {
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
