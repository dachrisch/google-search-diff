import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/service/localstore.dart';
import 'package:injectable/injectable.dart';

import 'db_init_service.dart';
import 'db_service.dart';

@injectable
class DbHistoryService extends DbService<Query> {
  DbHistoryService({required super.localStore, required super.collection});

  @factoryMethod
  @preResolve
  static Future<DbHistoryService> fromDb(LocalStoreService localStore) =>
      DbInitService(collection: '.history', localStore: localStore)
          .init((json) => Query.fromJson(json))
          .then((queryIdMap) => DbHistoryService(
                localStore: localStore,
                collection: '.history',
              ));
}
