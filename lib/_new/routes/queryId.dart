import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class QueryId {
  final String queryId;

  QueryId(this.queryId);

  static fromState(GoRouterState state) =>
      QueryId(state.pathParameters['queryId']!);

  static withUuid() => QueryId(Uuid().v4());
}
