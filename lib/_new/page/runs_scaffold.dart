import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/provider/query_result_model.dart';
import 'package:google_search_diff/_new/widget/header_listview.dart';
import 'package:provider/provider.dart';

class RunsScaffold extends StatelessWidget {
  const RunsScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QueryRunsModel queryRuns = context.watch<QueryRunsModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Query - ${queryRuns.query.query}'),
      ),
      body: ListViewWithHeader(
        items: queryRuns.items,
        itemBuilder: (context, index) => QueryResultCardResultsModelProvider(
            resultsModel: queryRuns.runAt(index)),
        headerText: 'Runs',
      ),
      floatingActionButton: FloatingActionButton.small(
          key: const Key('refresh-query-results-button'),
          onPressed: () => queryRuns.addRun(RunModel.empty()),
          child: const Icon(Icons.refresh_outlined)),
    );
  }
}
