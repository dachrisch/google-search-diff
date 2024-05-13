import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:logger/logger.dart';
import 'package:relative_time/relative_time.dart';

class RunDragTarget extends StatefulWidget {
  final Logger l = getLogger('RunDragTarget');
  final void Function(Run run) onAcceptRun;
  final bool Function(Run run) willAcceptRun;
  final void Function() onRemoveRun;

  final Run? acceptedRun;

  RunDragTarget({
    super.key,
    this.acceptedRun,
    required this.willAcceptRun,
    required this.onAcceptRun,
    required this.onRemoveRun,
  });

  @override
  State<StatefulWidget> createState() => _RunDragTargetState();
}

class _RunDragTargetState extends State<RunDragTarget> {
  final Logger l = getLogger('RunDragTarget');

  bool get hasRun => widget.acceptedRun != null;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Run>(
      onAcceptWithDetails: (details) {
        l.d('accepting $details');
        widget.onAcceptRun(details.data);
      },
      onWillAcceptWithDetails: (details) {
        l.d('Check to accept: $details');
        return !hasRun && widget.willAcceptRun(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        l.d('Drop has already ${widget.acceptedRun} and is receiving $candidateData, $rejectedData');
        return hasRun
            ? TargetWithRun(
                run: widget.acceptedRun!,
                onRemoveRun: () => setState(() {
                      l.d('removing run $widget.acceptedRun');
                      widget.onRemoveRun();
                    }))
            : EmptyTarget(isHighlighted: candidateData.isNotEmpty);
      },
    );
  }
}

class TargetWithRun extends StatelessWidget {
  final Run run;
  final void Function() onRemoveRun;

  const TargetWithRun(
      {super.key, required this.run, required this.onRemoveRun});

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Stack(
      children: [
        SizedBox(
            height: 120.0,
            width: 120.0,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: themeData.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
            )),
        Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: onRemoveRun,
              child: const Icon(Icons.cancel_rounded),
            ))
      ],
    );
  }
}

class EmptyTarget extends StatelessWidget {
  final bool isHighlighted;

  const EmptyTarget({
    super.key,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120.0,
        width: 120.0,
        child: Card(
          elevation: isHighlighted ? 12 : 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: isHighlighted ? Colors.grey[600] : Colors.grey[100],
          child: Center(
            child: Icon(
              Icons.select_all,
              color: Colors.grey[600],
            ),
          ),
        ));
  }
}
