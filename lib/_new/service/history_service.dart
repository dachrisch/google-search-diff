import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';

class HistoryService extends ChangeNotifier {
  final Set<Query> _queries = {};

  final DbQueriesService dbQueryService = DbQueriesService.of('.history');

  HistoryService() {
    dbQueryService
        .fetchAllQueries()
        .then((allQueries) => _queries.addAll(allQueries));
  }

  void addQuery(Query query) {
    dbQueryService.saveQuery(query).then((_) => _queries.add(query));
  }

  List<Query> get queries => _queries.toList();

  List<Query> getMatching(Query query) {
    return query.term.isEmpty
        ? _queries.toList()
        : _queries
            .where((element) =>
                element.term.toLowerCase().contains(query.term.toLowerCase()))
            .toList();
  }

  remove(Query query) {
    dbQueryService
        .saveQuery(query)
        .then((_) => _queries.remove(query))
        .then((_) => notifyListeners());
  }
}
