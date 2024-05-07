import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:localstore/localstore.dart';
import 'package:logger/logger.dart';

class DbRunsService {
  final Localstore db = Localstore.instance;
  final Logger l = getLogger('db');
  final Map<Run, String> runsIdMap = {};

  late Future<void> loadFuture;

  DbRunsService._() {
    loadFuture = db.collection('.runs').get().then((allQueryRunsJson) {
      l.d('Loading [${allQueryRunsJson?.length}] Runs');
      allQueryRunsJson?.entries.forEach((q) {
        var run = Run.fromJson(q.value);
        l.d('Loaded $run');
        runsIdMap.putIfAbsent(run, () => q.key);
      });
    });
  }

  factory DbRunsService() => DbRunsService._();

  Future<void> saveRuns(List<Run> runs) => Future.sync(() async {
        for (var element in runs) {
          await saveRun(element);
        }
      });

  Future<void> saveRun(Run run) {
    String id = db.collection('.runs').doc().id;
    l.d('Saving $run with [$id]');
    return db
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
    return db.collection('.runs').doc(id).delete();
  }

  Future<List<Run>> fetchAllRuns() =>
      loadFuture.then((value) => runsIdMap.keys.toList());

  Future<List<Run>> fetchRunsForQuery(Query query) =>
      fetchAllRuns().then((value) => runsIdMap.keys
          .where((element) => element.query.id == query.id)
          .toList());
}
