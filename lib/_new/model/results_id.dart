import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/uuid_mixin.dart';
import 'package:uuid/uuid.dart';

class ResultsId with UuidMixin {
  ResultsId(String id) {
    initId(id);
  }

  static withUuid() => ResultsId(const Uuid().v4());

  static fromState(GoRouterState state) =>
      ResultsId(state.pathParameters['resultsId']!);
}
