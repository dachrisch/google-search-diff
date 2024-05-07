import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/comparison.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/widget/run_card_list_tile.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class RunCard extends StatefulWidget {
  final void Function(bool isDragging) onDragChanged;

  const RunCard({super.key, required this.onDragChanged});

  @override
  State<StatefulWidget> createState() => _RunCardState();
}

class _RunCardState extends State<RunCard> with TimerMixin {
  final Logger l = getLogger('RunCard');

  @override
  Widget build(BuildContext context) {
    Run run = context.read<Run>();
    QueryRuns queryRuns = context.watch<QueryRuns>();
    ResultComparison resultComparison =
        queryRuns.nextRecentTo(run).compareTo(run);
    var relativeTime = RelativeTime(context);
    return LongPressDraggable<Run>(
        data: run,
        dragAnchorStrategy: (draggable, context, position) => Offset(50, 50),
        onDragStarted: () => widget.onDragChanged(true),
        onDragEnd: (details) => widget.onDragChanged(false),
        feedback: Container(
            width: 100,
            height: 100,
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '${run.items} items',
                      ),
                      Icon(Icons.notes_sharp),
                    ],
                  ),
                ),
              ),
            )),
        child: Dismissible(
          key: Key(run.id.id.toString()),
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
          child: RunCardListTile(
              run: run,
              relativeTime: relativeTime,
              resultComparison: resultComparison,
              queryRuns: queryRuns),
        ));
  }
}
