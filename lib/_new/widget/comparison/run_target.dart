import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:logger/logger.dart';
import 'package:relative_time/relative_time.dart';

class RunDragTarget extends StatefulWidget {
  final Logger l = getLogger('RunDragTarget');
  final void Function(Run run) onAcceptRun;
  final bool Function(Run run) willAcceptRun;

  RunDragTarget({
    required this.onAcceptRun,
    super.key,
    required this.willAcceptRun,
  });

  @override
  State<StatefulWidget> createState() => _RunDragTargetState();
}

class _RunDragTargetState extends State<RunDragTarget> {
  final Logger l = getLogger('RunDragTarget');
  Run? acceptedRun;

  bool get hasRun => acceptedRun != null;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Run>(
      onAcceptWithDetails: (details) {
        l.d('accepting $details');
        acceptedRun = details.data;
        widget.onAcceptRun(details.data);
      },
      onWillAcceptWithDetails: (details) {
        l.d('Check to accept: $details');
        return !hasRun && widget.willAcceptRun(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        l.d('Drop has: $candidateData, $rejectedData');
        return hasRun
            ? TargetWithRun(run: acceptedRun!)
            : EmptyTarget(isHighlighted: candidateData.isEmpty);
      },
    );
  }
}

class TargetWithRun extends StatelessWidget {
  final Run run;

  const TargetWithRun({required this.run});

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return SizedBox(
        height: 100.0,
        width: 100.0,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: themeData.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    RelativeTime(context).format(run.runDate),
                    style: themeData.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const Icon(Icons.notes_sharp),
                  Text('${run.items} items',
                      style: themeData.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ));
  }
}

class EmptyTarget extends StatelessWidget {
  final bool isHighlighted;

  const EmptyTarget({
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100.0,
        width: 100.0,
        child: Card(
          elevation: isHighlighted ? 4 : 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: isHighlighted ? Colors.grey[100] : Colors.grey[600],
          child: Center(
            child: Icon(
              Icons.select_all,
              color: Colors.grey[600],
            ),
          ),
        ));
  }
}
