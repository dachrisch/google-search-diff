// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:logger/logger.dart';

extension ButtonTap on WidgetTester {
  Future<int> tapButtonByKey(String key) async {
    final Logger l = getLogger('ButtonTap');
    l.d('Tapping key $key');
    await tap(find.byKey(Key(key)));
    return pumpAndSettle(); // https://stackoverflow.com/questions/49542389/flutter-get-a-popupmenubuttons-popupmenuitem-text-in-unit-tests
  }
}

extension Grab on WidgetTester {
  FutureOr<TestGesture> grabCard<T extends Widget>(
          Finder Function(Finder found) selector) =>
      startGesture(getCenter(selector(find.byType(T)))).then((gesture) async {
        await pumpAndSettle();
        return gesture;
      });

  Future<Finder> moveCardToTarget<T, V>(
      TestGesture gesture, Finder Function(Finder found) selector) async {
    var dropTarget = selector(find.byType(T));
    Offset dropTargetOffset = getCenter(dropTarget);

    expect(find.descendant(of: dropTarget, matching: find.byType(V)),
        findsOneWidget);
    await gesture.moveTo(dropTargetOffset);
    await gesture.up();
    await pumpAndSettle();
    return dropTarget;
  }
}
