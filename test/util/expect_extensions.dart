// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void expectBadgeVisible(bool isVisible) {
  expect(
      ((find.byKey(const Key('saved-searches-badge')).evaluate().first
                  as StatelessElement)
              .widget as Badge)
          .isLabelVisible,
      isVisible);
}

void expectBadgeLabel(String text) {
  expectBadgeVisible(true);
  expect(
      (((find.byKey(const Key('saved-searches-badge')).evaluate().first
                      as StatelessElement)
                  .widget as Badge)
              .label as Text)
          .data,
      text);
}

void expectSearchField(String text) {
  expect(
      (find.byKey(const Key('search-query-field')).evaluate().first.widget
              as TextField)
          .controller
          ?.text,text
      );
}
