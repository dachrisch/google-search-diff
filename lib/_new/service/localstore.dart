import 'package:injectable/injectable.dart';
import 'package:localstore/localstore.dart';

@singleton
class LocalStoreService {
  final Localstore _db = Localstore.instance;

  CollectionRefImpl collection(String collection) => _db.collection(collection);
}
