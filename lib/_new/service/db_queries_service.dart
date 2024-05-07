import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:localstore/localstore.dart';
import 'package:logger/logger.dart';

class DbQueriesService {
  final Localstore db = Localstore.instance;
  final Logger l = getLogger('db');
  final Map<Query, String> queryIdMap = {};

  late Future<void> loadFuture;

  DbQueriesService._() {
    loadFuture = db.collection('.queries').get().then((allQueriesJson) {
      l.d('Loading [${allQueriesJson?.length}] Queries');
      allQueriesJson?.entries.forEach((q) {
        var query = Query.fromJson(q.value);
        l.d('Loaded $query');
        queryIdMap.putIfAbsent(query, () => q.key);
      });
    });
  }

  factory DbQueriesService() => DbQueriesService._();

  Future<void> saveQuery(Query query) {
    String id = db.collection('.queries').doc().id;
    l.d('Saving $query with [$id]');
    return db
        .collection('.queries')
        .doc(id)
        .set(query.toJson())
        .then((value) => queryIdMap.putIfAbsent(query, () => id));
  }

  Future<void> removeQuery(Query query) async {
    var id = queryIdMap.remove(query);
    l.d('Deleting $query with [$id]');
    return db.collection('.queries').doc(id).delete();
  }

  Future<List<Query>> fetchAllQueries() =>
      loadFuture.then((value) => queryIdMap.keys.toList());
}
