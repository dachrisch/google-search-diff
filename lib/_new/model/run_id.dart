import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/entity_id.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'run_id.g.dart';

@JsonSerializable()
class RunId extends EntityId {
  RunId(super.id);

  static withUuid() => RunId(const Uuid().v4());

  static fromState(GoRouterState state) =>
      RunId(state.pathParameters['runId']!);

  factory RunId.fromJson(Map<String, dynamic> json) => _$RunIdFromJson(json);

  Map<String, dynamic> toJson() => _$RunIdToJson(this);
}
