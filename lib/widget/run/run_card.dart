import 'package:flutter/material.dart';
import 'package:google_search_diff/action/intent/remove_run.dart';
import 'package:google_search_diff/action/remove_run.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/comparison/run_feedback_card.dart';
import 'package:google_search_diff/widget/run/run_card_list_tile.dart';
import 'package:google_search_diff/widget/timer_mixin.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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

    return Actions(
      actions: {
        RemoveRunIntent: RemoveRunAction(context, queryRuns: queryRuns)
      },
      child: Builder(
          builder: (context) => LongPressDraggable<Run>(
              data: run,
              dragAnchorStrategy: (draggable, context, position) =>
                  const Offset(170, 70),
              onDragStarted: () => widget.onDragChanged(true),
              onDragEnd: (details) => widget.onDragChanged(false),
              onDragCompleted: () => widget.onDragChanged(false),
              onDraggableCanceled: (velocity, offset) =>
                  widget.onDragChanged(false),
              onDragUpdate: (details) {
                l.d('drag update $details');
              },
              feedback: RunFeedbackCard(run: run),
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
                // https://www.dhiwise.com/post/how-to-implement-flutter-swipe-action-cell-in-mobile-app
                onDismissed: (direction) =>
                    Actions.invoke(context, RemoveRunIntent(run: run)),
                child: RunCardListTile(
                    run: run,
                    resultComparison: resultComparison,
                    queryRuns: queryRuns),
              ))),
    );
  }
}
