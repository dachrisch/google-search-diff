import 'dart:async';
import 'package:fimber/fimber.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:localstore/localstore.dart';

class SearchesStore {
  final String _c = '.search';
  final Localstore _db;
  final logger = FimberLog('db');
  StreamSubscription<Map<String, dynamic>>? _subscription;

  static final SearchesStore _singleton = SearchesStore._internal();

  SearchesStore._internal() : _db = Localstore.getInstance(useSupportDir: true);

  factory SearchesStore() => _singleton;

  Future<Map<String, dynamic>?> findAll() =>
      _db.collection(_c).get().then((allSearches) {
        logger.d('Reading existing searches: $allSearches');
        return allSearches;
      });

  StreamSubscription<SearchResultsMapType> listen(
      void Function(SearchResultsMapType event) onData) {
    return _subscription =
        _db.collection(_c).stream.listen((SearchResultsMapType event) {
      logger.d('New db event: $event');
      return onData(event);
    }, cancelOnError: true);
  }

  Future insert(SearchResultsMapType json) {
    final id = _db.collection(_c).doc().id;
    logger.d('Storing $this with [$id]: $json');
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
          logger.d('deleting $element [$id]');

          return _db.collection(_c).doc(element?.key).delete();});
  }

  void cancelSubscription() async {
    return await _subscription?.cancel();
  }
}
