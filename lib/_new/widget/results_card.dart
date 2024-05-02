import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:provider/provider.dart';

class QueryResultCard extends StatelessWidget {
  final ResultsModel queryResults;

  const QueryResultCard(this.queryResults, {super.key});

  @override
  Widget build(BuildContext context) {
    var searchQuery = context.watch<QueryModel>();
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
          onTap: () => {},
          child: ListTile(
            title: Text('Created: ${queryResults.queryDate}'),
            subtitle: const Text('sub'),
            trailing: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 1.0, color: Colors.white))),
                child: IconButton(
                  key: Key('delete-query-results-${queryResults.resultsId}'),
                  icon: const Icon(Icons.delete),
                  onPressed: () => searchQuery.removeResults(queryResults),
                )),
          )),
    );
  }
}
