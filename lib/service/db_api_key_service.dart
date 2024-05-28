import 'package:google_search_diff/model/api_key.dart';
import 'package:google_search_diff/service/db_init_service.dart';
import 'package:google_search_diff/service/localstore.dart';
import 'package:injectable/injectable.dart';

import 'db_service.dart';

@injectable
class DbApiKeyService extends DbService<ApiKey> {
  DbApiKeyService(
      {required super.itemToIdMap,
      required super.localStore,
      required super.collection});

  @factoryMethod
  @preResolve
  static Future<DbApiKeyService> fromDb(LocalStoreService localStore) =>
      DbInitService<ApiKey>(collection: '.api_key', localStore: localStore)
          .init((json) => ApiKey.fromJson(json))
          .then((apiKeyMap) => DbApiKeyService(
                localStore: localStore,
                collection: '.api_key',
                itemToIdMap: apiKeyMap,
              ));
}
