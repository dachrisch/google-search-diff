import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:localstore/localstore.dart';
import 'package:logger/logger.dart';

class DbRunsService {
  final Localstore db = Localstore.instance;
  final Logger l = getLogger('db');
  final Map<RunModel, String> queryRunsIdMap = {};

  late Future<void> loadFuture;

  DbRunsService._() {
    loadFuture = db.collection('.runs').get().then((allQueryRunsJson) {
      l.d('Loading [${allQueryRunsJson?.length}] QueryRuns');
      allQueryRunsJson?.entries.forEach((q) {
        var queryRuns = RunModel.fromJson(q.value);
        l.d('Loaded $queryRuns');
        queryRunsIdMap.putIfAbsent(queryRuns, () => q.key);
      });
    });
  }

  factory DbRunsService() => DbRunsService._();

  Future<void> saveQueryRuns(List<RunModel> queryRuns) => Future.sync(() async {
        for (var element in queryRuns) {
          await saveQueryRun(element);
        }
      });

  Future<void> saveQueryRun(RunModel queryRun) {
    String id = db.collection('.runs').doc().id;
    l.d('Saving $queryRun with [$id]');
    return db
        .collection('.runs')
        .doc(id)
        .set(queryRun.toJson())
        .then((value) => queryRunsIdMap.putIfAbsent(queryRun, () => id));
  }

  Future<void> removeQueryRuns(List<RunModel> queryRuns) async =>
      Future(() async {
        for (var element in queryRuns) {
          await removeQueryRun(element);
        }
      });

  Future<void> removeQueryRun(RunModel queryRun) async {
    var id = queryRunsIdMap.remove(queryRun);
    l.d('Deleting $queryRun with [$id]');
    return db.collection('.runs').doc(id).delete();
  }

  Future<List<RunModel>> fetchAllQueryRunsModels() =>
      loadFuture.then((value) => queryRunsIdMap.keys.toList());

  Future<List<RunModel>> fetchRunsForQuery(Query query) =>
      fetchAllQueryRunsModels().then((value) => queryRunsIdMap.keys
          .where((element) => element.query.queryId == query.queryId)
          .toList());
}
