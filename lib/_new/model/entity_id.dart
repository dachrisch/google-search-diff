import 'package:uuid/parsing.dart';

abstract class EntityId {
  final String id;

  @override
  String toString() => 'QueryId(id: $id)';

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is EntityId && id == other.id;

  EntityId(this.id) {
    // validate uuid
    UuidParsing.parse(id);
  }
}