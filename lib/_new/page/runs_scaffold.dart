import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/provider/query_result_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/animated_icon_button.dart';
import 'package:google_search_diff/_new/widget/header_listview.dart';
import 'package:provider/provider.dart';

class RunsScaffold extends StatelessWidget {
  const RunsScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QueryRunsModel queryRuns = context.watch<QueryRunsModel>();
    SearchService searchService = context.read<SearchService>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Query - ${queryRuns.query.term}'),
      ),
      body: ListViewWithHeader(
        items: queryRuns.items,
        itemBuilder: (context, index) => QueryResultCardResultsModelProvider(
            resultsModel: queryRuns.runAt(index)),
        headerText: 'Runs',
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: AnimatedRefreshIconButton(
            buttonKey: const Key('refresh-query-results-button'),
            onPressed: () => searchService
                .doSearch(queryRuns.query)
                .then((run) => queryRuns.addRun(run)),
          )),
    );
  }
}
