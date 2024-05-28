import 'package:flutter/material.dart';
import 'package:google_search_diff/filter/prompt.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/header_listview.dart';
import 'package:google_search_diff/widget/results/result_card.dart';
import 'package:google_search_diff/widget/results/results_page_provider.dart';
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
          tooltip: 'Back to all runs',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Query run - ${run.query.term}'),
      ),
      body: ListViewWithHeader(
        items: filteredResults.length,
        itemBuilder: (context, index) =>
            ResultCard(result: filteredResults[index]),
        headerText: 'Results',
        filterWidget: PromptFilterChoice(
          title: const Text('Filter Sources'),
          filterOptions: run.results.fold({}, (map, result) {
            map[result.source] = (map[result.source] ?? 0) + 1;
            return map;
          }),
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
}

