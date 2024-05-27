import 'package:flutter/material.dart';
import 'package:google_search_diff/action/intent/remove_run.dart';
import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/route_navigate_extension.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:relative_time/relative_time.dart';

class RunCardListTile extends StatelessWidget {
  const RunCardListTile({
    super.key,
    required this.run,
    required this.resultComparison,
    required this.queryRuns,
  });

  final Run run;
  final ResultComparison resultComparison;
  final QueryRuns queryRuns;

  Widget rowFor<T extends ComparedResult>() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          compareResultProperties[T]!.icon,
          const SizedBox(width: 16,),
          SizedBox(width:70, child: Text('${compareResultProperties[T]!.name}: ')),
          Text(resultComparison.count<T>().toString()),
        ],
      );

  @override
  Widget build(BuildContext context) {
    var relativeTime = RelativeTime(context);
    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      child: InkWell(
          onTap: () => context.goRelativeWithId(run.id),
          child: ListTile(
            leading: const Icon(Icons.list_outlined),
            title: Text('Created: ${relativeTime.format(run.runDate)}'),
            subtitle: Column(
              children: [
                rowFor<AddedResult>(),
                rowFor<ExistingResult>(),
                rowFor<RemovedResult>(),
              ],
            ),
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
