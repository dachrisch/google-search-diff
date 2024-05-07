import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:localstore/localstore.dart';
import 'package:logger/logger.dart';

class DbRunsService {
  final Localstore db = Localstore.instance;
  final Logger l = getLogger('db');
  final Map<Results, String> queryRunsIdMap = {};

  late Future<void> loadFuture;

  DbRunsService._() {
    loadFuture = db.collection('.runs').get().then((allQueryRunsJson) {
      l.d('Loading [${allQueryRunsJson?.length}] QueryRuns');
      allQueryRunsJson?.entries.forEach((q) {
        var queryRuns = Results.fromJson(q.value);
        l.d('Loaded $queryRuns');
        queryRunsIdMap.putIfAbsent(queryRuns, () => q.key);
      });
    });
  }

  factory DbRunsService() => DbRunsService._();

  Future<void> saveQueryRuns(List<Results> queryRuns) => Future.sync(() async {
        for (var element in queryRuns) {
          await saveQueryRun(element);
        }
      });

  Future<void> saveQueryRun(Results queryRun) {
    String id = db.collection('.runs').doc().id;
    l.d('Saving $queryRun with [$id]');
    return db
        .collection('.runs')
        .doc(id)
        .set(queryRun.toJson())
        .then((value) => queryRunsIdMap.putIfAbsent(queryRun, () => id));
  }

  Future<void> removeQueryRuns(List<Results> queryRuns) async =>
      Future(() async {
        for (var element in queryRuns) {
          await removeQueryRun(element);
        }
      });

  Future<void> removeQueryRun(Results queryRun) async {
    var id = queryRunsIdMap.remove(queryRun);
    l.d('Deleting $queryRun with [$id]');
    return db.collection('.runs').doc(id).delete();
  }

  Future<List<Results>> fetchAllQueryRunsModels() =>
      loadFuture.then((value) => queryRunsIdMap.keys.toList());

  Future<List<Results>> fetchRunsForQuery(Query query) =>
      fetchAllQueryRunsModels().then((value) => queryRunsIdMap.keys
          .where((element) => element.query.queryId == query.queryId)
          .toList());
}
