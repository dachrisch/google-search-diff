import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';

class HistoryService extends ChangeNotifier {
  final Set<Query> _queries = {};

  List<Query> get queries => _queries.toList();

  void addQuery(Query query) {
    _queries.add(query);
  }

  List<Query> getMatching(Query query) {
    return query.term.isEmpty
        ? _queries.toList()
        : _queries
            .where((element) =>
                element.term.toLowerCase().contains(query.term.toLowerCase()))
            .toList();
  }

  remove(Query query) {
    _queries.remove(query);
    notifyListeners();
  }
}
