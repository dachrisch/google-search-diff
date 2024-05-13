import 'package:go_router/go_router.dart';
import 'package:google_search_diff/model/entity_id.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'run_id.g.dart';

@JsonSerializable()
class RunId extends EntityId {
  RunId(super.id);

  RunId.fromState(GoRouterState state, String parameterName)
      : super(state.pathParameters[parameterName]!);

  factory RunId.withUuid() => RunId(const Uuid().v4());

  factory RunId.fromJson(Map<String, dynamic> json) => _$RunIdFromJson(json);

  Map<String, dynamic> toJson() => _$RunIdToJson(this);
}
