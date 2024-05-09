import 'package:google_search_diff/_new/model/run.dart';

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
}
