import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/model/run_id.dart';

Map<Type, ComparedResultViewProperties> compareResultProperties = {
  AddedResult: ComparedResultViewProperties(
      name: 'Added',
      iconData: Icons.keyboard_double_arrow_right_outlined,
      color: Colors.green),
  RemovedResult: ComparedResultViewProperties(
      name: 'Removed',
      iconData: Icons.keyboard_double_arrow_left_outlined,
      color: Colors.red),
  ExistingResult: ComparedResultViewProperties(
      name: 'Existing',
      iconData: Icons.pause_circle_outline,
      color: Colors.grey)
};

class ComparedResultViewProperties {
  final IconData iconData;
  final MaterialColor color;
  final String name;

  ComparedResultViewProperties(
      {required this.iconData, required this.color, required this.name});

  Icon get icon => Icon(iconData, color: color);

  static ComparedResultViewProperties of(ComparedResult element) =>
      compareResultProperties[element.runtimeType]!;
}

class ComparisonViewModel {
  Run? base;
  Run? current;

  ComparisonViewModel({this.base, this.current});

  void dropCurrent(Run run) {
    current = run;
  }

  void dropBase(Run run) {
    base = run;
  }

  bool notContains(Run run) => run != base && run != current;

  bool get isEmpty => base == null && current == null;

  bool get isNotEmpty => !isEmpty;

  bool get isComplete => base != null && current != null;

  ResultComparison get compareResult => isComplete
      ? base!.compareTo(current!)
      : throw ArgumentError('Comparison is not complete');

  void removeBase() {
    base = null;
  }

  void removeCurrent() {
    current = null;
  }
}

class BaseRunId extends RunId {
  BaseRunId(GoRouterState state) : super.fromState(state, 'baseId');
}

class CurrentRunId extends RunId {
  CurrentRunId(GoRouterState state) : super.fromState(state, 'currentId');
}
