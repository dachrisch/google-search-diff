import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/service/localstore.dart';
import 'package:injectable/injectable.dart';

import 'db_init_service.dart';
import 'db_service.dart';

@singleton
class DbRunsService extends DbService<Run> {
  DbRunsService({required super.localStore, required super.collection});

  @factoryMethod
  @preResolve
  static Future<DbRunsService> fromDb(LocalStoreService localStore) =>
      DbInitService(collection: '.runs', localStore: localStore)
          .init((json) => Run.fromJson(json))
          .then((queryIdMap) => DbRunsService(
                localStore: localStore,
                collection: '.runs',
              ));
}
