import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class HistoryService extends ChangeNotifier {
  final Set<Query> _queries = {};

  final DbQueriesService dbQueryService;

  HistoryService({required this.dbQueryService}) {
    _queries.addAll(dbQueryService.fetchAllQueries());
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
