import 'package:flutter/material.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/result_id.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/route_navigate_extension.dart';
import 'package:google_search_diff/service/result_service.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:google_search_diff/widget/results/result_card.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
                .addRun(
                    Run(query, [result], runDate: DateTime.now().subtract(const Duration(hours: 1))))
                .then((_) => queryRuns)),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done
            ? Provider.value(value: result.id, child: ResultPage())
            : const Center(
                child: Text('Loading'),
              ));
  }
}

class ResultPage extends StatelessWidget {
  final ResultService resultService = getIt<ResultService>();

  ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    var resultId = context.read<ResultId>();
    return Provider(
      create: (context) => resultService.resultById(resultId),
      child: ResultPageScaffold(),
    );
  }
}

class ResultPageScaffold extends StatelessWidget {
  final ResultService resultService = getIt<ResultService>();

  ResultPageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    Result result = context.read<Result>();
    List<ResultHistory> resultHistory = resultService.resultHistory(result);
    var format = RelativeTime(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Result - History'),
      ),
      body: Column(
        children: [
          Center(
              child: ResultCard(
            result: result,
          )),
          Expanded(
            child: ListView.builder(
              itemCount: resultHistory.length,
              itemBuilder: (context, index) {
                var viewProperties = ComparedResultViewProperties.of(
                    resultHistory[index].comparedResult);
                var run = resultHistory[index].run;
                return TimelineTile(
                  alignment: TimelineAlign.center,
                  isFirst: index == 0,
                  isLast: index == resultHistory.length - 1,
                  indicatorStyle: IndicatorStyle(
                      height: 40,
                      width: 40,
                      color: Colors.white,
                      iconStyle: IconStyle(
                          iconData: viewProperties.iconData,
                          color: viewProperties.color)),
                  startChild: ListTile(
                    title: Row(
                      children: [
                        Text(viewProperties.name),
                        Spacer(),
                        Text(
                          format.format(run.runDate),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  endChild: ListTile(
                    title: Row(
                      children: [
                        Text('Results: ${run.results.length}'),
                        Spacer(),
                        TextButton(
                            onPressed: () => context.gotToRun(run),
                            child: Text(
                              'View run',
                              textAlign: TextAlign.right,
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
