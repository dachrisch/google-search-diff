import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queryResults.dart';
import 'package:google_search_diff/_new/model/searchQuery.dart';
import 'package:google_search_diff/_new/widget/queryResultsCard.dart';
import 'package:provider/provider.dart';

class SingleQueryScaffold extends StatelessWidget {
  const SingleQueryScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchQuery = context.watch<SearchQueryModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(searchQuery.query),
      ),
      body: ListView.builder(
          itemCount: searchQuery.results.length,
          itemBuilder: (context, index) =>
              QueryResultCard(searchQuery.resultsAt(index))),
      floatingActionButton: FloatingActionButton.small(
          onPressed: () => searchQuery.addResults(QueryResultsModel()),
          child: const Icon(Icons.refresh_outlined)),
    );
  }
}
