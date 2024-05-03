import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/routes/relative_route_extension.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class SingleQueryCard extends StatefulWidget {
  const SingleQueryCard({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SingleQueryCard();
}

class _SingleQueryCard extends State<SingleQueryCard> with TimerMixin {
  @override
  Widget build(BuildContext context) {
    QueryRunsModel queryRuns = context.watch<QueryRunsModel>();

    QueriesStoreModel searchQueriesStore = context.watch<QueriesStoreModel>();

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
          onTap: () => context.goRelative('${queryRuns.query.id}'),
          child: ListTile(
            leading: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white))),
              child: IconButton(
                key: const Key('refresh-query-results-outside-button'),
                icon: const Icon(Icons.refresh_outlined),
                onPressed: () => queryRuns.addRun(RunModel.empty()),
              ),
            ),
            title: Text(queryRuns.query.query),
            subtitle: Row(
              children: [
                Text('Results: ${queryRuns.items}'),
                const SizedBox(
                  width: 30,
                ),
                Text(
                    'Updated: ${queryRuns.items > 0 ? RelativeTime(context).format(queryRuns.latest.queryDate) : 'N/A'}')
              ],
            ),
            trailing: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 1.0, color: Colors.white))),
                child: IconButton(
                  key: Key('delete-search-query-${queryRuns.query.id}'),
                  icon: const Icon(Icons.delete),
                  onPressed: () => searchQueriesStore.remove(queryRuns),
                )),
          )),
    );
  }
}
