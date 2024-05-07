import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/intent/search.dart';
import 'package:google_search_diff/_new/action/search_and_add_run.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/provider/results_scaffold_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/animated_icon_button.dart';
import 'package:google_search_diff/_new/widget/run_card.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class RunsPage extends StatelessWidget {
  const RunsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const QueryRunsProvider(child: RunsPageScaffold());
}

class RunsPageScaffold extends StatefulWidget {
  const RunsPageScaffold({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RunsPageScaffoldState();
}

class _RunsPageScaffoldState extends State<RunsPageScaffold> with TimerMixin {
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
    QueryRuns queryRuns = context.watch<QueryRuns>();
    SearchService searchService = context.read<SearchService>();
    return Actions(
        actions: {
          SearchIntent: SearchAndAddRunAction(searchService: searchService)
        },
        child: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text('Query - ${queryRuns.query.term}'),
                  ),
                  body: GroupedListView(
                    elements: queryRuns.runs,
                    itemBuilder: (context, run) => ChangeNotifierProvider.value(
                        value: run, child: const RunCard()),
                    groupSeparatorBuilder: (TimeUnit value) =>
                        Center(child: Text(groups[value]!)),
                    groupBy: (Run rm) {
                      try {
                        return TimeUnit.values.firstWhere((tu) =>
                            tu.difference(
                                rm.runDate.difference(DateTime.now()).abs()) >
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
                        onPressed: () =>
                            Actions.invoke(context, SearchIntent(queryRuns)),
                      )),
                )));
  }
}
