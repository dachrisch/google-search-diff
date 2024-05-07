import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/provider/query_result_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/animated_icon_button.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class RunsScaffold extends StatefulWidget {
  const RunsScaffold({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RunsScaffoldState();
}

class _RunsScaffoldState extends State<RunsScaffold> with TimerMixin {
  final Map<TimeUnit, String> groups = {
    TimeUnit.second: 'Now',
    TimeUnit.minute: 'Recently',
    TimeUnit.hour: 'Today',
    TimeUnit.day: 'Couple Days',
    TimeUnit.month: 'Older',
    TimeUnit.year: 'Older'
  };

  @override
  Widget build(BuildContext context) {
    QueryRunsModel queryRuns = context.watch<QueryRunsModel>();
    SearchService searchService = context.read<SearchService>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Query - ${queryRuns.query.term}'),
      ),
      body: GroupedListView(
        elements: queryRuns.runs,
        itemBuilder: (context, element) =>
            QueryResultCardResultsModelProvider(resultsModel: element),
        groupSeparatorBuilder: (TimeUnit value) =>
            Center(child: Text(groups[value]!)),
        groupBy: (RunModel rm) {
          try {
            return TimeUnit.values.firstWhere((tu) =>
                tu.difference(rm.runDate.difference(DateTime.now()).abs()) >
                1);
          } on StateError {
            return TimeUnit.second;
          }
        },
        itemComparator: (element1, element2) =>
            element2.runDate.compareTo(element1.runDate),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: AnimatedRefreshIconButton(
            buttonKey: const Key('refresh-query-results-button'),
            onPressed: () => searchService
                .doSearch(queryRuns.query)
                .then((run) => queryRuns.addRun(run)),
          )),
    );
  }
}
