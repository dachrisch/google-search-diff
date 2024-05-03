import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/provider/query_result_model.dart';
import 'package:provider/provider.dart';

class ResultsScaffold extends StatelessWidget {
  const ResultsScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QueryModel searchQuery = context.watch<QueryModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Query - ${searchQuery.query.query}'),
      ),
      body: ListView.builder(
          itemCount: searchQuery.items,
          itemBuilder: (context, index) => QueryResultCardResultsModelProvider(
              resultsModel: searchQuery.resultsAt(index))),
      floatingActionButton: FloatingActionButton.small(
          key: const Key('refresh-query-results-button'),
          onPressed: () => searchQuery.addResults(ResultsModel.empty()),
          child: const Icon(Icons.refresh_outlined)),
    );
  }
}
