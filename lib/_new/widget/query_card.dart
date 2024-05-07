import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/relative_route_extension.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/animated_icon_button.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class SingleQueryCard extends StatefulWidget {
  const SingleQueryCard({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SingleQueryCard();
}

class _SingleQueryCard extends State<SingleQueryCard>
    with TimerMixin, TickerProviderStateMixin {
  final Logger l = getLogger('QueryCard');

  @override
  Widget build(BuildContext context) {
    QueryRunsModel queryRuns = context.watch<QueryRunsModel>();
    QueriesStoreModel searchQueriesStore = context.watch<QueriesStoreModel>();
    SearchService searchService = context.read<SearchService>();

    return Dismissible(
        key: Key(queryRuns.hashCode.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.all(10),
          color: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8)
            ],
          ),
        ),
        onDismissed: (direction) {
          // https://www.dhiwise.com/post/how-to-implement-flutter-swipe-action-cell-in-mobile-app

          searchQueriesStore.remove(queryRuns);
          // Show a snackbar with undo action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Query "${queryRuns.query.term}" removed'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () async {
                  l.d('Restore $queryRuns');
                  searchQueriesStore.add(queryRuns);
                },
              ),
            ),
          );
        },
        child: Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: InkWell(
              onTap: () => context.goRelativeWithId(queryRuns.query.queryId),
              child: ListTile(
                  leading: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            right:
                                BorderSide(width: 1.0, color: Colors.white))),
                    child: AnimatedRefreshIconButton(
                        buttonKey: Key(
                            'refresh-query-results-outside-button-${queryRuns.query.queryId.id}'),
                        onPressed: () => searchService
                            .doSearch(queryRuns.query)
                            .then((run) => queryRuns.addRun(run))),
                  ),
                  title: Text(queryRuns.query.term),
                  subtitle: Row(
                    children: [
                      Text('Results: ${queryRuns.items}'),
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                          'Updated: ${queryRuns.items > 0 ? RelativeTime(context).format(queryRuns.latest.runDate) : 'N/A'}')
                    ],
                  ),
                  trailing: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(width: 1.0, color: Colors.white))),
                    child: IconButton(
                        key: Key(
                            'delete-search-query-${queryRuns.query.queryId}'),
                        icon: const Icon(Icons.delete),
                        onPressed: () => searchQueriesStore.remove(queryRuns)),
                  ))),
        ));
  }
}
