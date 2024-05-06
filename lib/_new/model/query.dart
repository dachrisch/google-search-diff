import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query.g.dart';

@JsonSerializable()
class Query {
  final String term;
  final QueryId queryId;

  Query(this.term, {QueryId? queryId})
      : queryId = queryId ?? QueryId.withUuid();

  @override
  int get hashCode => term.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Query && other.term == term && other.queryId == queryId;
  }

  @override
  String toString() => 'Query(term: $term, queryId: $queryId)';

  factory Query.empty() => Query('');

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  Map<String, dynamic> toJson() => _$QueryToJson(this);
}
