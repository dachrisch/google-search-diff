// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/router_app.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/search/search_service_provider.dart';
import 'package:google_search_diff/service/db_queries_service.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:google_search_diff/service/file_picker_service.dart';
import 'package:google_search_diff/service/history_service.dart';
import 'package:google_search_diff/service/queries_store_share_service.dart';
import 'package:google_search_diff/service/result_service.dart';
import 'package:google_search_diff/theme.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../util/service_mocks.dart';

class Mocked {
  late QueriesStore queriesStore;
  final DbRunsService dbRunsService;
  final DbQueriesService dbQueriesService;
  final SearchServiceProvider searchServiceProvider;
  final HistoryService historyService;
  late QueriesStoreShareService queriesStoreExportService;
  late ResultService resultService;

  final FilePickerService filePickerService;

  Mocked(
      {QueriesStore? queriesStore,
      DbRunsService? dbRunsService,
      DbQueriesService? dbQueriesService,
      HistoryService? historyService,
      ResultService? resultService,
      FilePickerService? filePickerService,
      QueriesStoreShareService? queriesStoreExportService,
      SearchServiceProvider? searchServiceProvider})
      : dbRunsService = dbRunsService ?? MockDbRunsService(),
        historyService = historyService ?? MockHistoryService(),
        filePickerService = filePickerService ?? MockFilePickerService(),
        dbQueriesService = dbQueriesService ?? MockDbQueriesService(),
        searchServiceProvider = searchServiceProvider ??
            SearchServiceProvider(
              serpApiSearchService: MockSerpApiSearchService(),
              trySearchService: LoremIpsumSearchService(),
            ) {
    this.queriesStore = queriesStore ??
        QueriesStore(
            dbQueryService: this.dbQueriesService,
            dbRunsService: this.dbRunsService);
    this.resultService = resultService ??
        ResultService(
            dbRunsService: this.dbRunsService, queriesStore: this.queriesStore);
    this.queriesStoreExportService = queriesStoreExportService ??
        MockQueriesStoreExportService(
            queriesStore: this.queriesStore,
            dbRunsService: this.dbRunsService,
            dbQueriesService: this.dbQueriesService);
  }
}

extension MockedApp on WidgetTester {
  Future<Mocked> pumpMockedApp(Mocked mocked,
      {String? goto = '/queries'}) async {
    await initializeDateFormatting();

    if (!getIt.isRegistered<DbRunsService>()) {
      getIt.registerSingleton<DbRunsService>(mocked.dbRunsService);
    }
    if (!getIt.isRegistered<ResultService>()) {
      getIt.registerSingleton<ResultService>(mocked.resultService);
    }

    if (!getIt.isRegistered<FilePickerService>()) {
      getIt.registerSingleton<FilePickerService>(mocked.filePickerService);
    }

    if (!getIt.isRegistered<QueryRuns>()) {
      getIt.registerFactoryParam<QueryRuns, Run, Null>((param1, param2) =>
          QueryRuns.fromRun(param1, Mocked().dbRunsService));
    }

    if (!getIt.isRegistered<QueriesStoreShareService>()) {
      getIt.registerSingleton(QueriesStoreShareService(
          queriesStore: mocked.queriesStore,
          dbRunsService: mocked.dbRunsService,
          dbQueriesService: mocked.dbQueriesService));
    }

    var theme = MaterialTheme(ThemeData.light().primaryTextTheme);

    await pumpWidget(MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(0.5)),
      child: RouterApp(
        theme: theme,
        queriesStore: mocked.queriesStore,
        searchServiceProvider: mocked.searchServiceProvider,
        historyService: mocked.historyService,
      ),
    ));

    if (goto != null) {
      element(find.byType(Container)).go(goto);
    }
    await pumpAndSettle();

    return TestAsyncUtils.guard<Mocked>(() async => mocked);
  }
}
