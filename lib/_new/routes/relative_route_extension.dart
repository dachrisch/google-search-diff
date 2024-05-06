import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/entity_id.dart';

extension RelativeGoRouter on BuildContext {
  void goRelativeWithId(EntityId id, {Object? extra}) {

    final state = GoRouterState.of(this);
    final currentUrl = state.uri;
    String newPath = '${currentUrl.path}/${id.id}';
    for (final entry in state.pathParameters.entries) {
      newPath.replaceAll(':${entry.key}', entry.value);
    }
    final newUrl = currentUrl.replace(path: newPath, queryParameters: {
      ...currentUrl.queryParameters,
    });

    go(newUrl.toString(), extra: extra);
  }
}
