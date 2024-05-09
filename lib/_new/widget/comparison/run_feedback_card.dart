import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:relative_time/relative_time.dart';

class RunFeedbackCard extends StatelessWidget {
  final Run run;

  const RunFeedbackCard({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
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
