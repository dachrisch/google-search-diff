import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/route_navigate_extension.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:provider/provider.dart';

class ComparisonTestPage extends StatefulWidget {
  const ComparisonTestPage({super.key});

  @override
  State<StatefulWidget> createState() => _ComparisonTestPageState();
}

class _ComparisonTestPageState extends State<ComparisonTestPage> {
  @override
  void initState() {
    super.initState();
    QueriesStore store = context.read<QueriesStore>();
    var query = Query('Test 1');
    var baseRun = Run(
        query,
        [
          Result(
            title: loremIpsum(words: 5),
            source: loremIpsum(words: 1),
            snippet: loremIpsum(words: 20),
          )
        ],
        runDate: DateTime.now().subtract(const Duration(hours: 1)));
    var currentRun = Run(query, [
      Result(
        title: loremIpsum(words: 5),
        source: loremIpsum(words: 1),
        snippet: loremIpsum(words: 20),
      )
    ]);
    store
        .addQueryRuns(getIt<QueryRuns>(param1: baseRun))
        .then((queryRuns) => queryRuns.addRun(currentRun));
    initializeDateFormatting();
    Future.delayed(
        Durations.long1,
        () => context.goToComparison(
            ComparisonViewModel(base: baseRun, current: currentRun)));
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Compare Test Provider'),
    );
  }
}
