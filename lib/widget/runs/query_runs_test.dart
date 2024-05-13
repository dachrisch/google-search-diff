import 'package:flutter/material.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:google_search_diff/widget/runs/query_runs_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:provider/provider.dart';

class RunComparisonPageTest extends StatefulWidget {
  const RunComparisonPageTest({super.key});

  @override
  State<StatefulWidget> createState() => _RunComparisonPageTestState();
}

class _RunComparisonPageTestState extends State<RunComparisonPageTest> {
  late Run baseRun;
  late Run currentRun;
  late Query query;

  late QueriesStore store;

  @override
  void initState() {
    super.initState();
    store = context.read<QueriesStore>();
    query = Query('Comparison run test');
    baseRun = Run(
        query,
        [
          Result(
            title: loremIpsum(words: 5),
            source: loremIpsum(words: 1),
            snippet: loremIpsum(words: 20),
          )
        ],
        runDate: DateTime.now().subtract(const Duration(hours: 1)));
    currentRun = Run(query, [
      Result(
        title: loremIpsum(words: 5),
        source: loremIpsum(words: 1),
        snippet: loremIpsum(words: 20),
      )
    ]);

    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.done
          ? MultiProvider(providers: [
              ChangeNotifierProvider<QueryRuns>.value(value: snapshot.data!),
              Provider.value(
                  value:
                      ComparisonViewModel(base: baseRun, current: currentRun))
            ], child: const QueryRunsPageScaffold())
          : const Text('loading'),
      future: store
          .addQueryRuns(getIt<QueryRuns>(param1: baseRun))
          .then((queryRuns) {
        queryRuns.addRun(currentRun);
        return queryRuns;
      }),
    );
  }
}
