import 'package:flutter/cupertino.dart';
import 'package:google_search_diff/_new/model/query.dart';

class HistoryService extends ChangeNotifier {
  final Set<Query> _queries = {};

  List<Query> get queries => _queries.toList();

  void addQuery(Query query) {
    _queries.add(query);
  }

  List<Query> getMatching(Query query) {
    return query.query.isEmpty
        ? _queries.toList()
        : _queries
            .where((element) =>
                element.query.toLowerCase().contains(query.query.toLowerCase()))
            .toList();
  }

  remove(Query query) {
    _queries.remove(query);
    notifyListeners();
  }
}
