import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/model/run_id.dart';
import 'package:google_search_diff/service/localstore.dart';
import 'package:injectable/injectable.dart';

import 'db_init_service.dart';
import 'db_service.dart';

@singleton
class DbRunsService extends DbService<Run> {
  DbRunsService(
      {required super.localStore,
      required super.collection,
      required super.itemToIdMap});

  @factoryMethod
  @preResolve
  static Future<DbRunsService> fromDb(LocalStoreService localStore) =>
      DbInitService<Run>(collection: '.runs', localStore: localStore)
          .init((json) => Run.fromJson(json))
          .then((runToIdMap) => DbRunsService(
                localStore: localStore,
                collection: '.runs',
                itemToIdMap: runToIdMap,
              ));

  runById(RunId runId) => itemToIdMap.keys.firstWhere((run) => run.id == runId);
}
