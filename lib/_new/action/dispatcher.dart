import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:logger/logger.dart';

class LoggingActionDispatcher extends ActionDispatcher {
  final Logger l = getLogger('action');

  @override
  Object? invokeAction(covariant Action<Intent> action, covariant Intent intent,
      [BuildContext? context]) {
    l.d('Invoking $action with $intent');
    return super.invokeAction(action, intent, context);
  }
}
