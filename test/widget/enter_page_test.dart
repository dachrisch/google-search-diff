import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/model/api_key.dart';
import 'package:google_search_diff/widget/queries/queries_page.dart';

import '../service/widget_tester_extension.dart';
import '../util/service_mocks.dart';
import 'widget_tester_extension.dart';

void main() {
  testWidgets('Enter in try mode', (tester) async {
    var mocked = Mocked();

    await tester.pumpMockedApp(mocked, goto: null);

    await tester.tapButtonByKey('try-it-button');
    await tester.pumpAndSettle();
    expect(find.byType(QueriesPage), findsOneWidget);
    expect(mocked.searchServiceProvider.usedService,
        mocked.searchServiceProvider.trySearchService);
  });
  testWidgets('Enter with api key', (tester) async {
    var mocked = await tester.pumpMockedApp(Mocked(), goto: null);
    (mocked.searchServiceProvider.serpApiSearchService.apiKeyService
            as MockApiKeyService)
        .shouldValidate = true;

    await tester.enterText(find.byKey(const Key('api-key-text-field')), '1234');
    await tester.tapButtonByKey('login-with-key-button');
    await tester.pumpAndSettle();
    expect(find.byType(QueriesPage), findsOneWidget);
    expect(mocked.searchServiceProvider.usedService,
        mocked.searchServiceProvider.serpApiSearchService);
    expect(
        mocked.searchServiceProvider.serpApiSearchService.apiKeyService.apiKey,
        ApiKey(key: '1234'));
    expect(
        mocked.searchServiceProvider.serpApiSearchService.apiKeyService
            .propertiesApiKeyService
            .fetch(),
        ApiKey(key: '1234'));
  });
}
