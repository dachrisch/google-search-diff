import 'package:google_search_diff/_new/routes/query_id.dart';

class Query {
  final String query;
  final QueryId id;

  Query(this.query) : id = QueryId.withUuid();

  @override
  int get hashCode => query.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Query && other.query == query;
  }

  @override
  String toString() => query.toString();

  static Query empty() => Query('');
}
