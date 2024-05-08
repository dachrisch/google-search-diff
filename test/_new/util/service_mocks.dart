import 'package:google_search_diff/_new/service/db_history_service.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';
import 'package:google_search_diff/_new/service/history_service.dart';
import 'package:google_search_diff/_new/service/localstore.dart';
import 'package:localstore/localstore.dart';

class DocumentMock implements DocumentRef {
  Map<String, dynamic>? json;
  final String key;

  DocumentMock(String? key, this.json) : key = key ?? '123';

  @override
  CollectionRef collection(String id) {
    throw UnimplementedError();
  }

  @override
  Future delete() {
    json?.clear();
    return Future.value();
  }

  @override
  Future<Map<String, dynamic>?> get() {
    throw UnimplementedError();
  }

  @override
  String get id => key;

  @override
  String get path => throw UnimplementedError();

  @override
  Future set(Map<String, dynamic> data, [SetOptions? options]) {
    json = data;
    return Future.value();
  }
}

class CollectionMock implements CollectionRef {
  CollectionMock({required this.keyToJsonMap, this.checking = false});

  final Map<String, Map<String, dynamic>> keyToJsonMap;
  final bool checking;

  @override
  void addCondition(field, String operator, value) {}

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }

  @override
  DocumentRef doc([String? id]) {
    return DocumentMock(id, keyToJsonMap[id]);
  }

  @override
  Future<Map<String, dynamic>?> get() => Future.value(keyToJsonMap);

  @override
  CollectionRef? get parent => throw UnimplementedError();

  @override
  String get path => throw UnimplementedError();

  @override
  Stream<Map<String, dynamic>> get stream => throw UnimplementedError();

  @override
  CollectionRef where(field, {isEqualTo}) {
    throw UnimplementedError();
  }
}

class MockLocalStore extends LocalStoreService {
  @override
  CollectionRefImpl collection(String collection) {
    return CollectionMock(keyToJsonMap: {
      'test-123': {'term': 'test 1'}
    });
  }
}

class MockDbQueriesService extends DbQueriesService {
  MockDbQueriesService()
      : super(
            collection: 'test-queries',
            localStore: MockLocalStore(),
            itemToIdMap: {});
}

class MockDbHistoryService extends DbHistoryService {
  MockDbHistoryService()
      : super(
            collection: 'test-history',
            localStore: MockLocalStore(),
            itemToIdMap: {});
}

class MockDbRunsService extends DbRunsService {
  MockDbRunsService()
      : super(
            collection: 'test-runs',
            localStore: MockLocalStore(),
            itemToIdMap: {});
}

class MockHistoryService extends HistoryService {
  MockHistoryService() : super(dbHistoryService: MockDbHistoryService());
}
