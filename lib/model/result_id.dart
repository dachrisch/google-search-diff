import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'entity_id.dart';

part 'result_id.g.dart';

@JsonSerializable()
class ResultId extends EntityId {
  ResultId(super.id);

  factory ResultId.withUuid() => ResultId(const Uuid().v4());

  factory ResultId.fromState(GoRouterState state) =>
      ResultId(state.pathParameters['ResultId']!);

  factory ResultId.fromJson(Map<String, dynamic> json) =>
      _$ResultIdFromJson(json);

  Map<String, dynamic> toJson() => _$ResultIdToJson(this);
}
