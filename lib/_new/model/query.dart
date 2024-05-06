import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query.g.dart';

@JsonSerializable()
class Query {
  final String term;
  final QueryId queryId;

  Query(this.term, [QueryId? queryId])
      : queryId = queryId ?? QueryId.withUuid();

  factory Query.empty() => Query('');

  @override
  int get hashCode => term.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Query && other.term == term;
  }

  @override
  String toString() => 'Query(term: $term, id: $queryId)';

  Map<String, dynamic> toJson() => _$QueryToJson(this);

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);
}
