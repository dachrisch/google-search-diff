import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/intent/search.dart';
import 'package:google_search_diff/_new/action/search_and_add_run.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/provider/results_scaffold_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/card/run_card.dart';
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
  final ComparisonViewModel comparisonViewModel = ComparisonViewModel();

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
                        AnimatedContainer(
                          height: isDragging ? 150 : 150,
                          duration: const Duration(milliseconds: 200),
                          child: Column(
                            children: [
                              Text(
                                'Compare runs',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  RunDragTarget((data) =>
                                      comparisonViewModel.dropBase(data)),
                                  const Icon(Icons.compare_arrows_outlined),
                                  RunDragTarget((data) =>
                                      comparisonViewModel.dropCurrent(data)),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )));
  }
}

class ComparisonViewModel {
  Run? base;
  Run? current;

  void dropCurrent(Run run) {
    current = run;
  }

  void dropBase(Run run) {
    base = run;
  }
}

class RunDragTarget extends StatelessWidget {
  final Logger l = getLogger('RunDragTarget');
  final void Function(Run data) acceptData;

  RunDragTarget(
    this.acceptData, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<Run>(
      onAcceptWithDetails: (details) => acceptData(details.data),
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
              child: Center(
                child: Icon(
                  Icons.select_all,
                  color: Colors.grey[600],
                ),
              ),
            ));
      },
    );
  }
}
