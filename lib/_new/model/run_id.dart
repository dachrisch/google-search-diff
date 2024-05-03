import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/uuid_mixin.dart';
import 'package:uuid/uuid.dart';

class RunId with UuidMixin {
  RunId(String id) {
    initId(id);
  }

  static withUuid() => RunId(const Uuid().v4());

  static fromState(GoRouterState state) =>
      RunId(state.pathParameters['runId']!);
}
