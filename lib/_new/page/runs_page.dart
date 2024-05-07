import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/intent/search.dart';
import 'package:google_search_diff/_new/action/search_and_add_run.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/provider/results_scaffold_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/animated_icon_button.dart';
import 'package:google_search_diff/_new/widget/run_card.dart';
import 'package:google_search_diff/_new/widget/time_grouped_list_view.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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
  bool isDragging = false;

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
                  body: Column(
                    children: [
                      Text(
                        'Query runs',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Expanded(
                        child: TimeGroupedListView(
                          elements: queryRuns.runs,
                          headerText: 'Your query runs',
                          childWidgetBuilder: () => RunCard(
                              onDragChanged: (isDragging) => setState(() {
                                    this.isDragging = isDragging;
                                  })),
                          dateForItem: (Run item) => item.runDate,
                        ),
                      ),
                      AnimatedContainer(
                        height: isDragging ? 100 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RunDragTarget(),
                            RunDragTarget(),
                          ],
                        ),
                      )
                    ],
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

class RunDragTarget extends StatelessWidget {
  final Logger l = getLogger('RunDragTarget');

  RunDragTarget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<Run>(
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
            height: 100.0,
            width: 100.0,
            child: Card(
              elevation: candidateData.isEmpty ? 4 : 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color:
                  candidateData.isEmpty ? Colors.grey[100] : Colors.grey[600],
              child: const Center(
                child: Text(
                  'DROP_ITEMS_HERE',
                  style: TextStyle(color: Colors.black, fontSize: 22.0),
                ),
              ),
            ));
      },
    );
  }
}
