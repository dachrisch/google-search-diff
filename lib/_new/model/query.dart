import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query.g.dart';

@JsonSerializable()
class Query {
  final String term;
  final QueryId id;
  final DateTime createdDate;

  Query(this.term, {QueryId? id, DateTime? createdDate})
      : id = id ?? QueryId.withUuid(),
        createdDate = createdDate ?? DateTime.now();

  @override
  int get hashCode => term.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Query && other.term == term && other.id == id;
  }

  @override
  String toString() => 'Query(term: $term, queryId: $id)';

  factory Query.empty() => Query('');

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  Map<String, dynamic> toJson() => _$QueryToJson(this);
}
