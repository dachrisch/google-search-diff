import 'package:flutter/material.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/results/timeline/result_timeline_page.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:provider/provider.dart';

class ResultTestPage extends StatelessWidget {
  const ResultTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    QueriesStore store = context.read<QueriesStore>();
    var query = Query('Test 1');
    var result = Result(
      title: loremIpsum(words: 5),
      source: loremIpsum(words: 1),
      snippet: loremIpsum(words: 20),
    );
    var run = Run(query, [result],
        runDate: DateTime.now().subtract(const Duration(hours: 4)));

    return FutureBuilder(
        future: store
            .addQueryRuns(getIt<QueryRuns>(param1: run))
            .then((queryRuns) => queryRuns
                .addRun(Run(query, [],
                    runDate: DateTime.now().subtract(const Duration(hours: 3))))
                .then((_) => queryRuns))
            .then((queryRuns) => queryRuns
                .addRun(Run(query, [result],
                    runDate: DateTime.now().subtract(const Duration(hours: 2))))
                .then((_) => queryRuns))
            .then((queryRuns) => queryRuns
                .addRun(Run(query, [result], runDate: DateTime.now().subtract(const Duration(hours: 1))))
                .then((_) => queryRuns)),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done
            ? Provider.value(value: result.id, child: ResultTimelinePage())
            : const Center(
                child: Text('Loading'),
              ));
  }
}
