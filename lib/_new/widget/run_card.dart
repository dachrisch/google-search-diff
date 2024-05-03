import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/routes/relative_route_extension.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class RunCard extends StatefulWidget {
  const RunCard({super.key});

  @override
  State<StatefulWidget> createState() => _RunCardState();
}

class _RunCardState extends State<RunCard> with TimerMixin {
  @override
  Widget build(BuildContext context) {
    RunModel run = context.read<RunModel>();
    QueryRunsModel queryRuns = context.watch<QueryRunsModel>();
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
          onTap: () => context.goRelative(run.runId.toString()),
          child: ListTile(
            leading: const Icon(Icons.list_outlined),
            title: Text('Created: ${RelativeTime(context).format(run.queryDate)}'),
            subtitle: Text('Results: ${run.results.length}'),
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
    );
  }
}
