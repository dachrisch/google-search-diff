import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/provider/result_page.dart';
import 'package:google_search_diff/_new/widget/card/result_card.dart';
import 'package:google_search_diff/_new/widget/header_listview.dart';
import 'package:provider/provider.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) => ResultsPageResultsProvider();
}

class ResultsPageScaffold extends StatelessWidget {
  const ResultsPageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    Run results = context.read<Run>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Result - ${results.query.term}'),
        ),
        body: ListViewWithHeader(
          items: results.items,
          itemBuilder: (context, index) => ResultCard(results[index]),
          headerText: 'Results',
        ),
      ),
    );
  }
}
