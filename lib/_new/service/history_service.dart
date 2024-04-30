import 'package:google_search_diff/_new/routes/routes.dart';

class HistoryService {
  final List<Query> _queries = [];

  void addQuery(Query query) => _queries.add(query);

  List<Query> getMatching(Query query) {
    return query.query.isEmpty
        ? _queries
        : _queries
        .where(
            (element) => element.query.toLowerCase().contains(query.query))
        .toList();
  }
}
