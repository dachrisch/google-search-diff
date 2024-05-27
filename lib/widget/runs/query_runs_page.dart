import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/action/intent/search.dart';
import 'package:google_search_diff/action/search_and_add_run.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/widget/comparison/run_container.dart';
import 'package:google_search_diff/widget/run/run_card.dart';
import 'package:google_search_diff/widget/runs/query_runs_page_provider.dart';
import 'package:google_search_diff/widget/time_grouped_list_view.dart';
import 'package:google_search_diff/widget/timer_mixin.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class QueryRunsPage extends StatelessWidget {
  const QueryRunsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const QueryRunsPageProvider(child: QueryRunsPageScaffold());
}

class QueryRunsPageScaffold extends StatefulWidget {
  const QueryRunsPageScaffold({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _QueryRunsPageScaffoldState();
}

class _QueryRunsPageScaffoldState extends State<QueryRunsPageScaffold>
    with TimerMixin {
  final Logger l = getLogger('RunsPage');
  bool isDragging = false;
  final ScrollBehavior scrollBehavior = const MaterialScrollBehavior().copyWith(
      dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch});

  @override
  Widget build(BuildContext context) {
    QueryRuns queryRuns = context.watch<QueryRuns>();
    SearchService searchService =
        context.read<SearchServiceProvider>().usedService;
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
                                  scrollBehavior: scrollBehavior,
                                  slivers: [
                                    SliverAppBar(
                                      pinned: true,
                                      leading: IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () => context.pop(),
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
