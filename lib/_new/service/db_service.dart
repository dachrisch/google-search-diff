import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/has_to_json.dart';
import 'package:logger/logger.dart';

import 'localstore.dart';

abstract class DbService<T extends HasToJson> {
  final Logger l;
  final String collection;
  final LocalStoreService localStore;
  final Map<T, String> itemToIdMap = {};

  DbService({required this.localStore, required this.collection})
      : l = getLogger('db-$T[$collection]');

  Future<void> save(T item) {
    String id = localStore.collection(collection).doc().id;
    l.d('Saving $item with [$id]');
    return localStore
        .collection(collection)
        .doc(id)
        .set(item.toJson())
        .then((_) => itemToIdMap.putIfAbsent(item, () => id));
  }

  Future<void> removeAll(List<T> items) async =>
      items.map((element) => remove(element));

  Future<void> remove(T item) async {
    var id = itemToIdMap.remove(item);
    l.d('Deleting $item with [$id]');
    return localStore
        .collection(collection)
        .doc(id)
        .delete()
        .then((value) => l.d('Deleted $id, $value'))
        .onError((error, stackTrace) =>
            l.e('Error deleting $id', error: error, stackTrace: stackTrace));
  }

  List<T> fetchAll() => itemToIdMap.keys.toList();
}
