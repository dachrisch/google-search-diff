import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/entity_id.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/service/result_service.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';

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

  void goToComparison(ComparisonViewModel compareModel) {
    assert(compareModel.base != null);
    assert(compareModel.current != null);
    push('/compare/${compareModel.base!.id}/with/${compareModel.current!.id}');
  }

  void gotToRun(Run run) {
    push('/queries/${run.query.id}/runs/${run.id}');
  }

  void gotToResult(Result result) {
    ResultService resultService = getIt<ResultService>();
    Run run = resultService.latestRunOf(result);
    push('/queries/${run.query.id}/runs/${run.id}/results/${result.id}');
  }

  void goToEnter() {
    push('/enter');
  }

  void goToQueries() {
    push('/queries');
  }
}
