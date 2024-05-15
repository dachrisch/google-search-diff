import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/header_listview.dart';
import 'package:google_search_diff/widget/result/result_card.dart';
import 'package:google_search_diff/widget/result/result_page_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) => const ResultsPageResultsProvider();
}

class ResultsPageScaffold extends StatefulWidget {
  const ResultsPageScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _ResultsPageScaffoldState();
}

class _ResultsPageScaffoldState extends State<ResultsPageScaffold> {
  final Logger l = getLogger('run-page');

  final List<Result> filteredResults = [];

  @override
  void initState() {
    Run run = context.read<Run>();
    setState(() {
      filteredResults.addAll(run.results);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Run run = context.read<Run>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Result - ${run.query.term}'),
      ),
      body: ListViewWithHeader(
        items: filteredResults.length,
        itemBuilder: (context, index) =>
            ResultCard(result: filteredResults[index]),
        headerText: 'Results',
        filterWidget: FilterChoice(
          title: const Text('Filter Sources'),
          initialFilterValues:
              (run.results.map((r) => r.source).toSet().toList()),
          onFilterChanged: (newFilterList) {
            setState(() {
              filteredResults.clear();
              filteredResults.addAll(run.results
                  .where((element) => newFilterList.contains(element.source)));
            });
          },
        ),
      ),
    );
  }

  void openFilterList(BuildContext context) async {}
}

class FilterChoice extends StatefulWidget {
  final List<String> initialFilterValues;
  final void Function(List<String> newFilterList) onFilterChanged;
  final Widget title;

  const FilterChoice(
      {super.key,
      required this.initialFilterValues,
      required this.onFilterChanged,
      required this.title});

  @override
  State<StatefulWidget> createState() => _FilterChoiceState();
}

class _FilterChoiceState extends State<FilterChoice> {
  List<String> sortedFilter = [];
  final List<String> selectedFilterValues = [];

  @override
  void initState() {
    sortedFilter.addAll(widget.initialFilterValues);
    sortedFilter.sort();
    selectedFilterValues.addAll(sortedFilter);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Choice<String>.prompt(
      value: selectedFilterValues,
      multiple: true,
      clearable: true,
      searchable: true,
      itemSkip: (state, index) =>
          !ChoiceSearch.match(sortedFilter[index], state.search?.value),
      anchorBuilder: (state, openModal) =>
          IconButton(onPressed: openModal, icon: const Icon(Icons.filter_list)),
      onChanged: (newFilterList) {
        setState(() {
          selectedFilterValues.clear();
          selectedFilterValues.addAll(newFilterList);
          selectedFilterValues.sort();
        });
        widget.onFilterChanged(newFilterList);
      },
      itemCount: sortedFilter.length,
      itemBuilder: (state, i) {
        return CheckboxListTile(
          value: state.selected(sortedFilter[i]),
          onChanged: state.onSelected(sortedFilter[i]),
          title: ChoiceText(
            sortedFilter[i],
            highlight: state.search?.value,
          ),
        );
      },
      modalHeaderBuilder: ChoiceModal.createHeader(
        title: widget.title,
        actionsBuilder: [
          ChoiceModal.createConfirmButton(),
          ChoiceModal.createSpacer(width: 20),
        ],
      ),
      promptDelegate: ChoicePrompt.delegateNewPage(),
    );
  }
}
