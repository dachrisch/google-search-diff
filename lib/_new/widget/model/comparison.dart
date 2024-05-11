import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/model/run_id.dart';

class ComparisonViewModel {
  Run? base;
  Run? current;

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
}

class BaseRunId extends RunId {
  BaseRunId(GoRouterState state) : super.fromState(state, 'baseId');
}

class CurrentRunId extends RunId {
  CurrentRunId(GoRouterState state) : super.fromState(state, 'currentId');
}