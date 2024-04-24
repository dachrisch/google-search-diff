import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/main.dart';
import 'package:google_search_diff/model/search_results.dart';
import 'package:google_search_diff/service/search_provider.dart';
import 'package:google_search_diff/view/search_result_list_tile.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'util/expect_extensions.dart';
import 'util/widget_tester_extension.dart';

void main() {
  testWidgets('Test search produces 3 results', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));

    expect(find.byType(SearchResultListTile), findsNWidgets(0));

    await tester.performSearch('Test Search');

    expect(find.byType(SearchResultListTile), findsNWidgets(3));
  });

  testWidgets('Search on Enter key', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));

    expect(find.byType(SearchResultListTile), findsNWidgets(0));

    expect(find.byKey(const Key('search-query-field')), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('search-query-field')), 'Test Query');
    expectSearchField('Test Query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.byType(SearchResultListTile), findsNWidgets(3));
  });

  testWidgets('Escape clears search', (tester) async {
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));
    await tester.enterText(
        find.byKey(const Key('search-query-field')), 'Test Query');
    expectSearchField('Test Query');
    await simulateKeyDownEvent(LogicalKeyboardKey.escape);
    expectSearchField('');
  });

  testWidgets('Display alert when search produces an error', (tester) async {
    var performingSearchError = PerformingSearchError('Request took too long');
    await tester.pumpWidget(
        MyApp(retriever: FailingStaticRetriever(performingSearchError)));
    expect(find.byType(AlertDialog), findsNothing);
    await tester.enterText(
        find.byKey(const Key('search-query-field')), 'Test Query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOne);
    expect(
        (find.byType(AlertDialog).evaluate().first.widget as AlertDialog)
            .title
            .toString(),
        const Text('Error while searching').toString());
    expect(
        (find.byType(AlertDialog).evaluate().first.widget as AlertDialog)
            .content
            .toString(),
        Text('PerformingSearchError: ${performingSearchError.message}')
            .toString());
  });

  testWidgets('Expect Spinner to run during search', (tester) async {
    await tester.pumpWidget(MyApp(retriever: DelayingStaticRetriever(2)));
    await tester.enterText(
        find.byKey(const Key('search-query-field')), 'Test Query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOne);
    await tester
        .pumpAndSettle(); // https://stackoverflow.com/questions/72136532/flutter-integration-test-how-to-wait-until-element-is-disappear-with-specific-t
    expect(find.byType(SearchResultListTile), findsNWidgets(3));
  });

  testWidgets('Expect click on visit to follow link', (tester) async {
    await tester.pumpWidget(MyApp(retriever: StaticRetriever()));
    await tester.enterText(
        find.byKey(const Key('search-query-field')), 'Test Query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    var wasCalledNotifier = FakeUrlLauncher.registerWith();
    expect(find.widgetWithText(TextButton, 'Visit').first, findsOne);
    await tester.tap(find.widgetWithText(TextButton, 'Visit').first);
    expect(wasCalledNotifier.wasCalled, isTrue);
  });
}

class WasCalledHandler extends ChangeNotifier {
  bool wasCalled = false;
  void call() {
    wasCalled = true;
    notifyListeners();
  }
}

class FakeUrlLauncher extends UrlLauncherPlatform {
  @override
  LinkDelegate? get linkDelegate => null;
  static final WasCalledHandler wasCalledHandler = WasCalledHandler();

  static WasCalledHandler registerWith() {
    UrlLauncherPlatform.instance = FakeUrlLauncher();
    return wasCalledHandler;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) {
    wasCalledHandler.call();
    return Future.value(true);
  }
}

class FailingStaticRetriever extends StaticRetriever {
  final PerformingSearchError performingSearchError;
  FailingStaticRetriever(this.performingSearchError);

  @override
  Future<List<SearchResult>> query(String query) {
    return super.query(query).then((value) => throw performingSearchError);
  }
}

class DelayingStaticRetriever extends StaticRetriever {
  final int seconds;

  DelayingStaticRetriever(this.seconds);

  @override
  Future<List<SearchResult>> query(String query) {
    return Future.delayed(Duration(seconds: seconds), () => super.query(query));
  }
}
