import 'package:flutter/material.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/provider/result_page.dart';
import 'package:google_search_diff/widget/card/result_card.dart';
import 'package:google_search_diff/widget/header_listview.dart';
import 'package:provider/provider.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) => const ResultsPageResultsProvider();
}

class ResultsPageScaffold extends StatelessWidget {
  const ResultsPageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    Run results = context.read<Run>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Result - ${results.query.term}'),
      ),
      body: ListViewWithHeader(
        items: results.items,
        itemBuilder: (context, index) => ResultCard(result: results[index]),
        headerText: 'Results',
      ),
    );
  }
}
