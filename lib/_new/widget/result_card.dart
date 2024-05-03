import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/routes/relative_route_extension.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class QueryResultCard extends StatefulWidget {
  const QueryResultCard({super.key});

  @override
  State<StatefulWidget> createState() => _QueryResultCardState();
}

class _QueryResultCardState extends State<QueryResultCard> {
  @override
  Widget build(BuildContext context) {
    ResultsModel queryResults = context.read<ResultsModel>();
    QueryModel searchQuery = context.watch<QueryModel>();
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
          onTap: () => context.goRelative(queryResults.resultsId.toString()),
          child: ListTile(
            leading: const Icon(Icons.list_outlined),
            title: Text(
                'Created: ${RelativeTime(context).format(queryResults.queryDate)}'),
            subtitle: Text('Results: ${queryResults.results.length}'),
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
