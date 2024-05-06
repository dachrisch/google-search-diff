import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/parsing.dart';
import 'package:uuid/uuid.dart';

part 'query_id.g.dart';

@JsonSerializable()
class QueryId {
  final String id;

  @override
  String toString() => 'QueryId(id: $id)';

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is QueryId && id == other.id;

  QueryId(this.id) {
    // validate uuid
    UuidParsing.parse(id);
  }

  factory QueryId.withUuid() => QueryId(const Uuid().v4());

  factory QueryId.fromState(GoRouterState state) =>
      QueryId(state.pathParameters['queryId']!);

  factory QueryId.fromJson(Map<String, dynamic> json) =>
      _$QueryIdFromJson(json);

  Map<String, dynamic> toJson() => _$QueryIdToJson(this);
}
