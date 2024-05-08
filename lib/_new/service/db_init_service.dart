import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/has_to_json.dart';
import 'package:google_search_diff/_new/service/localstore.dart';
import 'package:logger/logger.dart';

class DbInitService<T extends HasToJson> {
  final Logger l = getLogger('db-init');
  final String collection;
  final LocalStoreService localStore;

  DbInitService({required this.collection, required this.localStore});

  Future<Map<T, String>> init(T Function(Map<String, dynamic> json) fromJson) =>
      localStore.collection(collection).get().then((allItemsJson) {
        l.d('Loading [${allItemsJson?.length}] Queries from [$collection]');
        var itemIdMap = <T, String>{};
        allItemsJson?.entries.forEach((q) {
          var value = fromJson(q.value);
          l.d('Loaded $value');
          itemIdMap.putIfAbsent(
              value, () => q.key.replaceFirst(RegExp('/?$collection/'), ''));
        });
        return itemIdMap;
      });
}
