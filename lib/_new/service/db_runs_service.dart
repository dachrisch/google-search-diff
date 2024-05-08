import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/service/localstore.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class DbRunsService {
  final Logger l = getLogger('db');
  final Map<Run, String> runsIdMap;
  final LocalStoreService localStore;

  DbRunsService({required this.runsIdMap, required this.localStore});

  @factoryMethod
  @preResolve
  static Future<DbRunsService> fromDb(LocalStoreService localStore) =>
      localStore.collection('.runs').get().then((allQueryRunsJson) {
        final Logger l = getLogger('db');
        l.d('Loading [${allQueryRunsJson?.length}] Runs');
        var runsIdMap = <Run, String>{};
        allQueryRunsJson?.entries.forEach((q) {
          var run = Run.fromJson(q.value);
          l.d('Loaded $run');
          runsIdMap.putIfAbsent(run, () => q.key);
        });
        return DbRunsService(runsIdMap: runsIdMap, localStore: localStore);
      });

  Future<void> saveRuns(List<Run> runs) => Future.sync(() async {
        for (var element in runs) {
          await saveRun(element);
        }
      });

  Future<void> saveRun(Run run) {
    String id = localStore.collection('.runs').doc().id;
    l.d('Saving $run with [$id]');
    return localStore
        .collection('.runs')
        .doc(id)
        .set(run.toJson())
        .then((value) => runsIdMap.putIfAbsent(run, () => id));
  }

  Future<void> removeRuns(List<Run> runs) async => Future(() async {
        for (var element in runs) {
          await removeRun(element);
        }
      });

  Future<void> removeRun(Run run) async {
    var id = runsIdMap.remove(run);
    l.d('Deleting $run with [$id]');
    return localStore.collection('.runs').doc(id).delete();
  }

  List<Run> fetchAllRuns() => runsIdMap.keys.toList();

  List<Run> fetchRunsForQuery(Query query) =>
      fetchAllRuns().where((element) => element.query.id == query.id).toList();
}
