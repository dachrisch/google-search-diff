import 'package:flutter/material.dart';
import 'package:google_search_diff/action/intent/remove_run.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/widget/snackbar.dart';
import 'package:logger/logger.dart';

class RemoveRunAction extends Action<RemoveRunIntent> {
  final QueryRuns queryRuns;
  final Logger l = getLogger('remove-query-action');

  final BuildContext context;

  RemoveRunAction(this.context, {required this.queryRuns});

  @override
  Object? invoke(RemoveRunIntent intent) => queryRuns
      .removeRun(intent.run)
      .then((_) => Future.sync(() => context.showSnackbar(
          title: 'Run deleted',
          actionLabel: 'Undo',
          onPressed: () async {
            l.d('Restore ${intent.run}');
            queryRuns.addRun(intent.run);
          })));
}
