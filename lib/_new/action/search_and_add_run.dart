import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/action/intent/search.dart';
import 'package:google_search_diff/_new/service/search_service.dart';

class SearchAndAddRunAction extends Action<SearchIntent> {
  final SearchService searchService;

  final BuildContext context;

  SearchAndAddRunAction(this.context, {required this.searchService});

  @override
  Object? invoke(SearchIntent intent) =>
      Future.sync(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Performing new run "${intent.queryRuns.query.term}"'),
              )))
          .then((controller) =>
              searchService.doSearch(intent.queryRuns.query).then((run) {
                controller.close;
                return intent.queryRuns.addRun(run);
              }))
          .then((run) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('New run finished with [${run.items}] results'),
                action: SnackBarAction(
                  label: 'visit',
                  onPressed: () =>
                      context.go('/queries/${run.query.id}/runs/${run.id}'),
                ),
              )));
}
