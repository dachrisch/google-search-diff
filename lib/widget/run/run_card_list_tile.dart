import 'package:flutter/material.dart';
import 'package:google_search_diff/action/intent/remove_run.dart';
import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/route_navigate_extension.dart';
import 'package:relative_time/relative_time.dart';

class RunCardListTile extends StatelessWidget {
  const RunCardListTile({
    super.key,
    required this.run,
    required this.relativeTime,
    required this.resultComparison,
    required this.queryRuns,
  });

  final Run run;
  final RelativeTime relativeTime;
  final ResultComparison resultComparison;
  final QueryRuns queryRuns;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      child: InkWell(
          onTap: () => context.goRelativeWithId(run.id),
          child: ListTile(
            leading: const Icon(Icons.list_outlined),
            title: Text('Created: ${relativeTime.format(run.runDate)}'),
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
                        Icon(Icons.compare_arrows_outlined, color: Colors.grey),
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
                        Text(resultComparison.added.toString()),
                        Text(resultComparison.existing.toString()),
                        Text(resultComparison.removed.toString()),
                      ],
                    ),
                  ],
                )),
            trailing: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 1.0, color: Colors.white))),
                child: IconButton(
                  key: Key('delete-query-results-${run.id}'),
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      Actions.invoke(context, RemoveRunIntent(run: run)),
                )),
          )),
    );
  }
}
