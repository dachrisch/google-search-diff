import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension RelativeGoRouter on BuildContext {
  void goRelative(String location, {Object? extra}) {
    assert(
      !location.startsWith('/'),
      "Relative locations must not start with a '/'.",
    );

    final state = GoRouterState.of(this);
    final currentUrl = state.uri;
    String newPath = '${currentUrl.path}/$location';
    for (final entry in state.pathParameters.entries) {
      newPath.replaceAll(':${entry.key}', entry.value);
    }
    final newUrl = currentUrl.replace(path: newPath, queryParameters: {
      ...currentUrl.queryParameters,
    });

    go(newUrl.toString(), extra: extra);
  }
}
