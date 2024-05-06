import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:localstore/localstore.dart';

class DbService {
  final Localstore db = Localstore.instance;
  final FimberLog l = FimberLog('db');
  final Map<Query, String> queryIdMap = {};

  DbService._();

  factory DbService() => DbService._();

  Future<void> saveQuery(Query query) {
    String id = db.collection('.queries').doc().id;
    l.d('Saving $query with [$id]');
    return db.collection('.queries').doc(id).set({'query': query.query}).then(
        (value) => queryIdMap.putIfAbsent(query, () => id));
  }

  Future<void> removeQuery(Query query) async {
    var id = queryIdMap.remove(query);
    l.d('Deleting $query with [$id]');
    return db.collection('.queries').doc(id).delete();
  }
}

class QueriesStoreModel extends ChangeNotifier {
  final List<QueryRunsModel> searchQueries = [];
  final DbService dbService = DbService();

  int get items => searchQueries.length;

  Future<void> add(QueryRunsModel queryModel) {
    return Future.sync(() => searchQueries.add(queryModel))
        .then((_) => dbService.saveQuery(queryModel.query))
        .then((value) => notifyListeners());
  }

  Future<void> remove(QueryRunsModel queryModel) =>
      Future.sync(() => searchQueries.remove(queryModel))
          .then((_) => dbService.removeQuery(queryModel.query))
          .then((value) => notifyListeners());

  QueryRunsModel at(int index) => searchQueries[index];

  QueryRunsModel findById(QueryId queryId) =>
      searchQueries.firstWhere((element) => element.query.id == queryId);
}
