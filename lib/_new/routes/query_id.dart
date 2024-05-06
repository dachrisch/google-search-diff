import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/parsing.dart';
import 'package:uuid/uuid.dart';

import '../model/entity_id.dart';

part 'query_id.g.dart';

@JsonSerializable()
class QueryId extends EntityId {
  QueryId(super.id);

  factory QueryId.withUuid() => QueryId(const Uuid().v4());

  factory QueryId.fromState(GoRouterState state) =>
      QueryId(state.pathParameters['queryId']!);

  factory QueryId.fromJson(Map<String, dynamic> json) =>
      _$QueryIdFromJson(json);

  Map<String, dynamic> toJson() => _$QueryIdToJson(this);
}


