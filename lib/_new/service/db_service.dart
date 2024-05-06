import 'package:google_search_diff/_new/model/query.dart';
import 'package:localstore/localstore.dart';

class DbService {
  final Localstore db = Localstore.getInstance(useSupportDir: true);
  static final DbService _instance = DbService();

  DbService();

  factory DbService.instance() => _instance;

  Future<List<Query>> fetchAllQueries() {
    return db.collection('.queries').get().then((allQueries) =>
        allQueries?.entries.map((q) => Query.fromJson(q.value)).toList() ??
        <Query>[]);
  }

  Future<Query> addQuery(Query query) {
    String id = db.collection('.queries').doc().id;
    return db
        .collection('.queries')
        .doc(id)
        .set(query.toJson())
        .then((_) => query);
  }

  Future<void> removeQuery(Query query) {
    return db
        .collection('.queries')
        .deleteItem((candidate) => Query.fromJson(candidate.value) == query);
  }
}

extension DeleteItem on CollectionRef {
  Future<void> deleteItem(
      bool Function(MapEntry<String, dynamic> candidate) matcher) {
    return get()
        .then((allDocuments) =>
            allDocuments?.entries.firstWhere((element) => matcher(element)))
        .then((element) {
      return doc(element?.key).delete();
    });
  }
}
