import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:logger/logger.dart';
import 'package:relative_time/relative_time.dart';

class RunFeedbackCard extends StatelessWidget {
  final Logger l = getLogger('feedback-card');
  final Run run;

  RunFeedbackCard({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    l.d('Grabbed card with $run');
    return SizedBox(
        width: 200,
        height: 100,
        child: Card(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text('Run ${RelativeTime(context).format(run.runDate)}'),
                  const Icon(Icons.notes_sharp),
                  Text(
                    '${run.items} items',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
