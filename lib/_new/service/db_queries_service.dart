import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/service/localstore.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@injectable
class DbQueriesService extends _DbQueriesService {
  DbQueriesService(
      {required super.localStore,
      required super.collection,
      required super.queryIdMap});

  @factoryMethod
  static Future<DbQueriesService> fromDb(LocalStoreService localStore) =>
      _DbQueriesService.fromDb('.queries', localStore).then((queryIdMap) =>
          DbQueriesService(
              localStore: localStore,
              collection: '.queries',
              queryIdMap: queryIdMap));
}

abstract class _DbQueriesService {
  final Logger l = getLogger('db');
  final String collection;
  final LocalStoreService localStore;
  final Map<Query, String> queryIdMap;

  _DbQueriesService(
      {required this.localStore,
      required this.collection,
      required this.queryIdMap});

  static Future<Map<Query, String>> fromDb(
          String collection, LocalStoreService localStore) =>
      localStore.collection(collection).get().then((allQueriesJson) {
        final Logger l = getLogger('db-init');
        l.d('Loading [${allQueriesJson?.length}] Queries from [$collection]');
        var queryIdMap = <Query, String>{};
        allQueriesJson?.entries.forEach((q) {
          var query = Query.fromJson(q.value);
          l.d('Loaded $query');
          queryIdMap.putIfAbsent(query, () => q.key);
        });
        return queryIdMap;
      });

  Future<void> saveQuery(Query query) {
    String id = localStore.collection(collection).doc().id;
    l.d('Saving $query with [$id]');
    return localStore
        .collection(collection)
        .doc(id)
        .set(query.toJson())
        .then((value) => queryIdMap.putIfAbsent(query, () => id));
  }

  Future<void> removeQuery(Query query) async {
    var id = queryIdMap.remove(query);
    l.d('Deleting $query with [$id]');
    return localStore
        .collection(collection)
        .doc(id)
        .delete()
        .then((value) => l.d('Deleted $id, $value'))
        .onError((error, stackTrace) =>
            l.e('Error deleting $id', error: error, stackTrace: stackTrace));
  }

  List<Query> fetchAllQueries() => queryIdMap.keys.toList();
}
