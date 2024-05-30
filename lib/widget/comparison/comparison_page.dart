import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/action/dispatcher.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/filter/prompt.dart';
import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/service/db_runs_service.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:google_search_diff/widget/results/result_card.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ComparisonPageProvider extends StatelessWidget {
  const ComparisonPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    BaseRunId baseRunId = context.read<BaseRunId>();
    CurrentRunId currentRunId = context.read<CurrentRunId>();
    var dbRunsService = getIt<DbRunsService>();
    var base = dbRunsService.runById(baseRunId);
    var current = dbRunsService.runById(currentRunId);
    return Provider(
      create: (context) => ComparisonViewModel(base: base, current: current),
      child: const ComparisonPage(),
    );
  }
}

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<StatefulWidget> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  final List<ComparedResult> filteredComparedResults = [];
  final List<String> filteredSources = [];
  final List<String> filteredStates = [];
  late ComparisonViewModel comparisonViewModel;

  @override
  void initState() {
    comparisonViewModel = context.read<ComparisonViewModel>();
    setState(() {
      filteredStates.addAll(compareResultProperties.values.map((r) => r.name));
      filteredSources.addAll(comparisonViewModel.compareResult.compared
          .fold<Set<String>>(<String>{}, (Set<String> previousValue, element) {
        previousValue.add(element.source);
        return previousValue;
      }));
      updateComparisonFilter();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
        actions: const <Type, Action<Intent>>{},
        dispatcher: LoggingActionDispatcher(),
        child: Builder(
            builder: (context) => Scaffold(
                    body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          ),
                          pinned: true,
                          title: Text(
                            'Run Comparison',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          actions: [
                            PromptFilterChoice(
                              title: const Text('Filter Results'),
                              filterOptions: comparisonViewModel
                                  .compareResult.compared
                                  .fold({}, (map, result) {
                                map[result.source] =
                                    (map[result.source] ?? 0) + 1;
                                return map;
                              }),
                              onFilterChanged: (List<String> newFilterList) {
                                setState(() {
                                  filteredSources.clear();
                                  filteredSources.addAll(newFilterList);
                                });
                                updateComparisonFilter();
                              },
                            ),
                            const SizedBox(
                              width: 16,
                            )
                          ],
                        ),
                        SliverPersistentHeader(
                            pinned: true,
                            delegate: RunComparisonHeaderDelegate(
                                comparison: comparisonViewModel)),
                        SliverPersistentHeader(
                            pinned: true,
                            delegate: StateFilterHeaderDelegate(
                                filteredStates: filteredStates,
                                onChanged: (List<String> newStates) {
                                  setState(() {
                                    filteredStates.clear();
                                    filteredStates.addAll(newStates);
                                  });
                                  updateComparisonFilter();
                                })),
                        SliverGroupedListView<ComparedResult, String>(
                          elements: filteredComparedResults,
                          groupBy: (ComparedResult element) =>
                              ComparedResultViewProperties.of(element).name,
                          itemComparator: (element1, element2) =>
                              element1.title.compareTo(element2.title),
                          itemBuilder: (context, element) => ResultCard(
                            result: element,
                            icon: ComparedResultViewProperties.of(element).icon,
                          ),
                          groupSeparatorBuilder: (value) =>
                              Text(value.toString()),
                          groupComparator: (value1, value2) =>
                              value1.toString().compareTo(value2.toString()),
                        ),
                      ],
                    ),
                  ),
                ))));
  }

  void updateComparisonFilter() {
    setState(() {
      filteredComparedResults.clear();
      filteredComparedResults.addAll(comparisonViewModel.compareResult.compared
          .where((element) => filteredSources.contains(element.source))
          .where(
            (element) => filteredStates
                .contains(ComparedResultViewProperties.of(element).name),
          ));
    });
  }
}

class RunComparisonHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ComparisonViewModel comparison;
  final double height;
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm', 'de_DE');

  RunComparisonHeaderDelegate({required this.comparison, this.height = 50});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).cardColor,
      alignment: Alignment.center,
      child: Text(
        '${dateFormat.format(comparison.base!.runDate)} <> ${dateFormat.format(comparison.current!.runDate)}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class StateFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> filteredStates;
  final double height;
  final void Function(List<String> newStates) onChanged;
  final List<ComparedResultViewProperties> crpList =
      compareResultProperties.values.toList();

  StateFilterHeaderDelegate(
      {required this.filteredStates,
      this.height = 50,
      required this.onChanged});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).cardColor,
      alignment: Alignment.center,
      child: Choice<String>.inline(
        value: filteredStates,
        multiple: true,
        clearable: true,
        listBuilder: ChoiceList.createScrollable(
          spacing: 10,
          runSpacing: 10,
        ),
        onChanged: (newStates) {
          onChanged(newStates);
        },
        itemCount: crpList.length,
        itemBuilder: (state, index) {
          return ChoiceChip(
            selected: state.selected(crpList[index].name),
            onSelected: state.onSelected(crpList[index].name),
            label: crpList[index].icon,
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
