import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/comparison.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/model/run_id.dart';

Map<Type, ComparedResultViewProperties> compareResultProperties = {
  AddedResult: ComparedResultViewProperties(
      Icons.keyboard_double_arrow_right_outlined, Colors.green),
  RemovedResult: ComparedResultViewProperties(
      Icons.keyboard_double_arrow_left_outlined, Colors.red),
  ExistingResult:
      ComparedResultViewProperties(Icons.compare_arrows_outlined, Colors.grey)
};

class ComparedResultViewProperties {
  final IconData iconData;
  final MaterialColor color;

  ComparedResultViewProperties(this.iconData, this.color);

  get icon => Icon(iconData, color: color);
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
