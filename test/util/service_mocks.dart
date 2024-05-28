import 'package:google_search_diff/model/api_key.dart';
import 'package:google_search_diff/search/api_key_service.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/service/db_history_service.dart';
import 'package:google_search_diff/service/db_queries_service.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:google_search_diff/service/history_service.dart';
import 'package:google_search_diff/service/localstore.dart';
import 'package:google_search_diff/service/properties_api_key_service.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class MockSharedProperties implements SharedPreferences {
  final Map<String, String> props = {};

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<bool> setString(String key, String value) {
    props.putIfAbsent(
      key,
      () => value,
    );
    return Future.value(true);
  }

  @override
  bool containsKey(String key) => props.containsKey(key);

  @override
  String? getString(String key) => props[key];
}

class MockPropertiesApiKeyService extends PropertiesApiKeyService {
  MockPropertiesApiKeyService() : super(preferences: MockSharedProperties());
}

class MockApiKeyService extends ApiKeyService {
  bool shouldValidate = false;

  MockApiKeyService()
      : super(propertiesApiKeyService: MockPropertiesApiKeyService());

  @override
  Future<bool> validateAndAccept(String key) {
    if (shouldValidate) {
      return propertiesApiKeyService.save(ApiKey(key: key)).then((_) => true);
    }
    return Future.value(shouldValidate);
  }
}

class MockSerpApiSearchService extends SerpApiSearchService {
  MockSerpApiSearchService() : super(MockApiKeyService());
}
