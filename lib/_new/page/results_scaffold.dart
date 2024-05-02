import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/widget/results_card.dart';
import 'package:provider/provider.dart';

class ResultsScaffold extends StatelessWidget {
  const ResultsScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchQuery = context.watch<QueryModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(searchQuery.query.query),
      ),
      body: ListView.builder(
          itemCount: searchQuery.items,
          itemBuilder: (context, index) =>
              QueryResultCard(searchQuery.resultsAt(index))),
      floatingActionButton: FloatingActionButton.small(
          key: const Key('refresh-query-results-button'),
          onPressed: () => searchQuery.addResults(ResultsModel()),
          child: const Icon(Icons.refresh_outlined)),
    );
  }
}
