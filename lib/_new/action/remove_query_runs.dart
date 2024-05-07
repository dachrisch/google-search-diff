import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/intent/remove_query_runs.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:logger/logger.dart';

class RemoveQueryRunsAction extends Action<RemoveQueryRunsIntent> {
  final QueriesStore queriesStore;

  final BuildContext context;
  final Logger l = getLogger('remove-query-runs-action');

  RemoveQueryRunsAction(this.context, {required this.queriesStore});

  @override
  Object? invoke(RemoveQueryRunsIntent intent) {
    queriesStore.remove(intent.queryRuns);
    // Show a snackbar with undo action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Query "${intent.queryRuns.query.term}" removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            l.d('Restore $intent.queryRuns');
            queriesStore.add(intent.queryRuns);
          },
        ),
      ),
    );
  }
}
