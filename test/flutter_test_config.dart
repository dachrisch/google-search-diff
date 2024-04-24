import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  WidgetController.hitTestWarningShouldBeFatal = true;
 Fimber.plantTree(DebugTree());

  return testMain();
}
