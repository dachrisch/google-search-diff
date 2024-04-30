import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class QueryId {
  final String _queryId;

  QueryId(this._queryId);

  static fromState(GoRouterState state) =>
      QueryId(state.pathParameters['queryId']!);

  static withUuid() => QueryId(const Uuid().v4());

  @override
  String toString() {
    return _queryId;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => _queryId.hashCode;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      _queryId == (other as QueryId)._queryId;
}
