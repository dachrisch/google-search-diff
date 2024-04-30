import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/uuidMixin.dart';
import 'package:uuid/uuid.dart';

class QueryId with UuidMixin {
  QueryId(String queryId) {
    initId(queryId);
  }

  static fromState(GoRouterState state) =>
      QueryId(state.pathParameters['queryId']!);

  static withUuid() => QueryId(const Uuid().v4());
}
