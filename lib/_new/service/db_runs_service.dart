import 'package:fimber/fimber.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:localstore/localstore.dart';

class DbRunsService {
  final Localstore db = Localstore.instance;
  final FimberLog l = FimberLog('db');
  final Map<QueryRunsModel, String> queryRunsIdMap = {};

  late Future<void> loadFuture;

  DbRunsService._() {
    loadFuture = db.collection('.runs').get().then((allQueryRunsJson) {
      l.d('Loading [${allQueryRunsJson?.length}] QueryRuns');
      allQueryRunsJson?.entries.forEach((q) {
        var queryRuns = QueryRunsModel.fromJson(q.value);
        l.d('Loaded $queryRuns');
        queryRunsIdMap.putIfAbsent(queryRuns, () => q.key);
      });
    });
  }

  factory DbRunsService() => DbRunsService._();

  Future<void> saveQueryRuns(QueryRunsModel queryRuns) {
    String id = db.collection('.runs').doc().id;
    l.d('Saving $queryRuns with [$id]');
    return db
        .collection('.runs')
        .doc(id)
        .set(queryRuns.toJson())
        .then((value) => queryRunsIdMap.putIfAbsent(queryRuns, () => id));
  }

  Future<void> removeQueryRuns(QueryRunsModel queryRuns) async {
    var id = queryRunsIdMap.remove(queryRuns);
    l.d('Deleting $queryRuns with [$id]');
    return db.collection('.runs').doc(id).delete();
  }

  Future<List<QueryRunsModel>> fetchAllQueryRunsModels() =>
      loadFuture.then((value) => queryRunsIdMap.keys.toList());

  Future<List<QueryRunsModel>> fetchRunsForQuery(Query query) =>
      fetchAllQueryRunsModels().then((value) => queryRunsIdMap.keys
          .where((element) => element.query.queryId == query.queryId)
          .toList());
}
