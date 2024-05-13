import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/action/intent/search.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/widget/snackbar.dart';

class SearchAndAddRunAction extends Action<SearchIntent> {
  final SearchService searchService;

  final BuildContext context;

  SearchAndAddRunAction(this.context, {required this.searchService});

  @override
  Object? invoke(SearchIntent intent) => Future.sync(() => context.showSnackbar(
          title: 'Performing new run "${intent.queryRuns.query.term}"'))
      .then((controller) =>
          searchService.doSearch(intent.queryRuns.query).then((run) {
            controller.close;
            return intent.queryRuns.addRun(run);
          }))
      .then(
        (run) => context.showSnackbar(
          title: 'New run finished with [${run.items}] results',
          actionLabel: 'Visit',
          onPressed: () =>
              context.go('/queries/${run.query.id}/runs/${run.id}'),
        ),
      );
}
