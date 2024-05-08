import 'package:google_search_diff/_new/service/db_history_service.dart';
import 'package:google_search_diff/_new/service/db_queries_service.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';
import 'package:google_search_diff/_new/service/history_service.dart';
import 'package:google_search_diff/_new/service/localstore.dart';

class MockLocalStore extends LocalStoreService {}

class MockDbQueriesService extends DbQueriesService {
  MockDbQueriesService()
      : super(collection: 'test-queries', localStore: MockLocalStore());
}

class MockDbHistoryService extends DbHistoryService {
  MockDbHistoryService()
      : super(collection: 'test-history', localStore: MockLocalStore());
}

class MockDbRunsService extends DbRunsService {
  MockDbRunsService()
      : super(collection: 'test-runs', localStore: MockLocalStore());
}

class MockHistoryService extends HistoryService {
  MockHistoryService() : super(dbHistoryService: MockDbHistoryService());
}
