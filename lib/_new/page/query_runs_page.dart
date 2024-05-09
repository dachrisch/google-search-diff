import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/intent/search.dart';
import 'package:google_search_diff/_new/action/search_and_add_run.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/provider/results_scaffold_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/card/run_card.dart';
import 'package:google_search_diff/_new/widget/comparison/run_container.dart';
import 'package:google_search_diff/_new/widget/time_grouped_list_view.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class QueryRunsPage extends StatelessWidget {
  const QueryRunsPage({super.key});

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
  final Logger l = getLogger('RunsPage');
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    QueryRuns queryRuns = context.watch<QueryRuns>();
    SearchService searchService = context.read<SearchService>();
    return Actions(
        actions: {
          SearchIntent:
              SearchAndAddRunAction(context, searchService: searchService)
        },
        child: Builder(
            builder: (context) => Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: Builder(builder: (context) {
                            var maxHeight =
                                Scaffold.of(context).appBarMaxHeight;
                            return RefreshIndicator(
                                edgeOffset: maxHeight ?? 80,
                                onRefresh: () => (Actions.invoke(
                                        context, SearchIntent(queryRuns))
                                    as Future<void>),
                                child: CustomScrollView(
                                  slivers: [
                                    SliverAppBar(
                                      pinned: true,
                                      leading: IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      title: Text(
                                          'Query - ${queryRuns.query.term}'),
                                    ),
                                    TimeGroupedListView(
                                      elements: queryRuns.runs,
                                      childWidgetBuilder: () => RunCard(
                                          onDragChanged: (isDragging) =>
                                              setState(() {
                                                l.d('isDragging = $isDragging');
                                                this.isDragging = isDragging;
                                              })),
                                      dateForItem: (Run item) => item.runDate,
                                      type: GroupListType.sliver,
                                    ),
                                  ],
                                ));
                          }),
                        ),
                        RunComparisonContainer(
                          isActive: isDragging,
                        )
                      ],
                    ),
                  ),
                )));
  }
}
