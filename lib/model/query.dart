import 'package:google_search_diff/model/has_to_json.dart';
import 'package:google_search_diff/routes/query_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query.g.dart';

@JsonSerializable(checked: true)
class Query implements HasToJson {
  final String term;
  final QueryId id;
  final DateTime createdDate;

  Query(this.term, {QueryId? id, DateTime? createdDate})
      : id = id ?? QueryId.withUuid(),
        createdDate = createdDate ?? DateTime.now();

  @override
  int get hashCode => Object.hashAll([term.hashCode, id.hashCode]);

  @override
  bool operator ==(Object other) {
    return other is Query && other.term == term && other.id == id;
  }

  @override
  String toString() => 'Query(term: $term, queryId: $id)';

  factory Query.empty() => Query('');

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QueryToJson(this);
}
