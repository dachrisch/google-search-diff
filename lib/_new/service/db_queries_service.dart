import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/service/localstore.dart';
import 'package:injectable/injectable.dart';

import 'db_init_service.dart';
import 'db_service.dart';

@injectable
class DbQueriesService extends DbService<Query> {
  DbQueriesService(
      {required super.localStore,
      required super.collection,
      required super.itemToIdMap});

  @factoryMethod
  @preResolve
  static Future<DbQueriesService> fromDb(LocalStoreService localStore) =>
      DbInitService<Query>(collection: '.queries', localStore: localStore)
          .init((json) => Query.fromJson(json))
          .then((queryIdMap) => DbQueriesService(
              localStore: localStore,
              collection: '.queries',
              itemToIdMap: queryIdMap));
}
