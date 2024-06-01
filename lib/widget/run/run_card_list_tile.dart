import 'package:flutter/material.dart';
import 'package:google_search_diff/action/intent/remove_run.dart';
import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/route_navigate_extension.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:relative_time/relative_time.dart';

class RunCardListTile extends StatefulWidget {
  final Run run;

  final Run previousRun;
  final QueryRuns queryRuns;

  RunCardListTile({
    super.key,
    required this.run,
    required this.queryRuns,
    required this.previousRun,
  });

  @override
  State<RunCardListTile> createState() => _RunCardListTileState();
}

class _RunCardListTileState extends State<RunCardListTile> {
  late ComparisonViewModel comparisonViewModel;

  @override
  void initState() {
    comparisonViewModel =
        ComparisonViewModel(current: widget.run, base: widget.previousRun);
    super.initState();
  }

  Widget rowFor<T extends ComparedResult>() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          compareResultProperties[T]!.icon,
          const SizedBox(
            width: 16,
          ),
          SizedBox(
              width: 70, child: Text('${compareResultProperties[T]!.name}: ')),
          Text(comparisonViewModel.compareResult.count<T>().toString()),
        ],
      );

  @override
  Widget build(BuildContext context) {
    var relativeTime = RelativeTime(context);
    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      child: InkWell(
          onTap: () {
            return context.goToComparison(comparisonViewModel);
          },
          child: ListTile(
            leading: const Icon(Icons.list_outlined),
            title: Text('Created: ${relativeTime.format(widget.run.runDate)}'),
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
                  key: Key('delete-query-results-${widget.run.id}'),
                  tooltip: 'Delete this run',
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      Actions.invoke(context, RemoveRunIntent(run: widget.run)),
                )),
          )),
    );
  }
}
