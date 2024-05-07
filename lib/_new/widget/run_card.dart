import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/comparison.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/routes/relative_route_extension.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class RunCard extends StatefulWidget {
  const RunCard({super.key});

  @override
  State<StatefulWidget> createState() => _RunCardState();
}

class _RunCardState extends State<RunCard> with TimerMixin {
  final Logger l = getLogger('RunCard');

  @override
  Widget build(BuildContext context) {
    RunModel run = context.read<RunModel>();
    QueryRunsModel queryRuns = context.watch<QueryRunsModel>();
    ResultComparison resultComparison =
        queryRuns.nextRecentTo(run).compareTo(run);
    return Dismissible(
      key: Key(run.runId.id.toString()),
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

        queryRuns.removeRun(run);
        // Show a snackbar with undo action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Run dismissed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                l.d('Restore $run');
                queryRuns.addRun(run);
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
        child: InkWell(
            onTap: () => context.goRelativeWithId(run.runId),
            child: ListTile(
              leading: const Icon(Icons.list_outlined),
              title:
                  Text('Created: ${RelativeTime(context).format(run.runDate)}'),
              subtitle: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_left_outlined, color: Colors.green),
                          Icon(Icons.compare_arrows_outlined,
                              color: Colors.grey),
                          Icon(Icons.arrow_right_outlined, color: Colors.red),
                        ],
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Added: '),
                          Text('Existing: '),
                          Text('Removed:')
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(resultComparison.added.length.toString()),
                          Text(resultComparison.existing.length.toString()),
                          Text(resultComparison.removed.length.toString()),
                        ],
                      ),
                    ],
                  )),
              trailing: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(width: 1.0, color: Colors.white))),
                  child: IconButton(
                    key: Key('delete-query-results-${run.runId}'),
                    icon: const Icon(Icons.delete),
                    onPressed: () => queryRuns.removeRun(run),
                  )),
            )),
      ),
    );
  }
}
