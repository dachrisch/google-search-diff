import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/service/localstore.dart';
import 'package:injectable/injectable.dart';

import 'db_init_service.dart';
import 'db_service.dart';

@injectable
class DbHistoryService extends DbService<Query> {
  DbHistoryService(
      {required super.localStore,
      required super.collection,
      required super.itemToIdMap});

  @factoryMethod
  @preResolve
  static Future<DbHistoryService> fromDb(LocalStoreService localStore) =>
      DbInitService<Query>(collection: '.history', localStore: localStore)
          .init((json) => Query.fromJson(json))
          .then((queryIdMap) => DbHistoryService(
                localStore: localStore,
                collection: '.history',
                itemToIdMap: queryIdMap,
              ));
}
