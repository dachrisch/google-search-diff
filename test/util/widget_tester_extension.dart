// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension ButtonTap on WidgetTester {
  Future<int> tapButton(String key) async {
    await tap(find.byKey(Key(key)));
    return pumpAndSettle(); // https://stackoverflow.com/questions/49542389/flutter-get-a-popupmenubuttons-popupmenuitem-text-in-unit-tests
  }

  Future<int> performSearch(String query) async {
    expect(find.byKey(const Key('search-query-field')), findsOneWidget);
    await enterText(find.byKey(const Key('search-query-field')), query);
    await tap(find.byKey(const Key('do-search-button')));
    return pumpAndSettle();
  }
}

