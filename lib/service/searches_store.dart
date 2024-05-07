import 'dart:async';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:localstore/localstore.dart';
import 'package:logger/logger.dart';

class SearchesStore {
  final String _c = '.search';
  final Localstore _db;
  final Logger l = getLogger('db');
  StreamSubscription<Map<String, dynamic>>? _subscription;

  static final SearchesStore _singleton = SearchesStore._internal();

  SearchesStore._internal() : _db = Localstore.getInstance(useSupportDir: true);

  factory SearchesStore() => _singleton;

  Future<Map<String, dynamic>?> findAll() =>
      _db.collection(_c).get().then((allSearches) {
        l.d('Reading existing searches: $allSearches');
        return allSearches;
      });

  StreamSubscription<SearchResultsMapType> listen(
      void Function(SearchResultsMapType event) onData) {
    return _subscription =
        _db.collection(_c).stream.listen((SearchResultsMapType event) {
      l.d('New db event: $event');
      return onData(event);
    }, cancelOnError: true);
  }

  Future insert(SearchResultsMapType json) {
    final id = _db.collection(_c).doc().id;
    l.d('Storing $this with [$id]: $json');
    return _db.collection(_c).doc(id).set(json);
  }

  void deleteById(String id) async {
    // `where is not implemented`
    // https://pub.dev/documentation/localstore/latest/localstore/CollectionRefImpl/where.html
    await _db
        .collection(_c)
        .get()
        .then((allDocuments) => allDocuments?.entries
            .firstWhere((element) => element.value['id'] == id))
        .then((element)  {
          l.d('deleting $element [$id]');

          return _db.collection(_c).doc(element?.key).delete();});
  }

  void cancelSubscription() async {
    return await _subscription?.cancel();
  }
}
