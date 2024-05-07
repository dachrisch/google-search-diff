import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/routes/relative_route_extension.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/animated_icon_button.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class SingleQueryCard extends StatefulWidget {
  final DateTime lastUpdated;

  const SingleQueryCard({
    super.key,
    required this.lastUpdated,
  });

  @override
  State<StatefulWidget> createState() => _SingleQueryCard();
}

class _SingleQueryCard extends State<SingleQueryCard>
    with TickerProviderStateMixin {
  final Logger l = getLogger('QueryCard');

  @override
  Widget build(BuildContext context) {
    QueryRunsModel queryRuns = context.watch<QueryRunsModel>();
    QueriesStoreModel searchQueriesStore = context.watch<QueriesStoreModel>();
    SearchService searchService = context.read<SearchService>();

    return Dismissible(
        key: Key(queryRuns.hashCode.toString()),
        direction: DismissDirection.horizontal,
        background: Container(
          margin: const EdgeInsets.all(10),
          color: Colors.amber,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 8),
              Icon(Icons.refresh_outlined, color: Colors.white),
            ],
          ),
        ),
        secondaryBackground: Container(
          margin: const EdgeInsets.all(10),
          color: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.delete_outline, color: Colors.white),
              SizedBox(width: 8)
            ],
          ),
        ),
        dismissThresholds: const {
          DismissDirection.endToStart: .2,
          DismissDirection.startToEnd: .2
        },
        confirmDismiss: (direction) => direction == DismissDirection.endToStart
            ? Future<bool>.value(true)
            : searchService
                .doSearch(queryRuns.query)
                .then((run) => queryRuns.addRun(run))
                .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Performing new run "${queryRuns.query.term}"'),
                ));
              }).then((_) => false),
        onDismissed: (direction) {
          // https://www.dhiwise.com/post/how-to-implement-flutter-swipe-action-cell-in-mobile-app
          if (direction == DismissDirection.startToEnd) {
            // refresh
          } else {
            // delete
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
          }
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
                          'Updated: ${queryRuns.items > 0 ? RelativeTime(context).format(widget.lastUpdated) : 'N/A'}')
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
