import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/intent/remove_query_runs.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/widget/snackbar.dart';
import 'package:logger/logger.dart';

class RemoveQueryRunsAction extends Action<RemoveQueryRunsIntent> {
  final QueriesStore queriesStore;

  final BuildContext context;
  final Logger l = getLogger('remove-query-runs-action');

  RemoveQueryRunsAction(this.context, {required this.queriesStore});

  @override
  Object? invoke(RemoveQueryRunsIntent intent) => queriesStore
      .remove(intent.queryRuns)
      .then((value) => context.showSnackbar(
          title: 'Query "${intent.queryRuns.query.term}" removed',
          actionLabel: 'Undo',
          onPressed: () async {
            l.d('Restore $intent.queryRuns');
            queriesStore.save(intent.queryRuns);
          }));
}
