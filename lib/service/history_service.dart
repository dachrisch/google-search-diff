import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/service/db_history_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class HistoryService extends ChangeNotifier {
  final HashSet<Query> _queries = HashSet(
    equals: (p0, p1) => p0.term == p1.term,
    hashCode: (p0) => p0.term.hashCode,
  );

  final DbHistoryService dbHistoryService;

  HistoryService({required this.dbHistoryService}) {
    _queries.addAll(dbHistoryService.fetchAll());
  }

  Future<Query?> addQuery(Query query) async =>
      Future.sync(() => _queries.add(query))
          .then((result) => result ? dbHistoryService.save(query) : null);

  List<Query> get queries => _queries.toList();

  List<Query> getMatching(Query query) {
    return query.term.isEmpty
        ? _queries.toList()
        : _queries
            .where((element) =>
                element.term.toLowerCase().contains(query.term.toLowerCase()))
            .toList();
  }

  Future<void> remove(Query query) => dbHistoryService
      .remove(query)
      .then((_) => _queries.remove(query))
      .then((_) => notifyListeners());
}
