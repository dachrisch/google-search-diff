import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/action/add_result.dart';
import 'package:google_search_diff/_new/action/dispatcher.dart';
import 'package:google_search_diff/_new/action/intent/add_result.dart';
import 'package:google_search_diff/_new/dependencies.dart';
import 'package:google_search_diff/_new/model/comparison.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/routes/relative_route_extension.dart';
import 'package:google_search_diff/_new/service/db_runs_service.dart';
import 'package:google_search_diff/_new/widget/model/comparison.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ComparisonPageTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ComparisonPageTestState();
}

class _ComparisonPageTestState extends State<ComparisonPageTest> {
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
        runDate: DateTime.now().subtract(Duration(hours: 1)));
    var currentRun = Run(query, [
      Result(
        title: loremIpsum(words: 5),
        source: loremIpsum(words: 1),
        snippet: loremIpsum(words: 20),
      )
    ]);
    AddResultsAction(store).invoke(AddResultsIntent(baseRun));
    AddResultsAction(store).invoke(AddResultsIntent(currentRun));
    initializeDateFormatting();
    Future.delayed(
        Durations.long1,
        () => context.goToComparison(
            ComparisonViewModel(base: baseRun, current: currentRun)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Compare Test Provider'),
    );
  }
}

class ComparisonPageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseRunId baseRunId = context.read<BaseRunId>();
    CurrentRunId currentRunId = context.read<CurrentRunId>();
    var dbRunsService = getIt<DbRunsService>();
    var base = dbRunsService.runById(baseRunId);
    var current = dbRunsService.runById(currentRunId);
    return Provider(
      create: (context) => ComparisonViewModel(base: base, current: current),
      child: ComparisonPage(),
    );
  }
}

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    var comparisonViewModel = context.read<ComparisonViewModel>();
    var compareResult = comparisonViewModel.compareResult;
    var dateFormat = DateFormat('dd.MM.yyyy HH:mm', 'de_DE');
    return Actions(
        actions: <Type, Action<Intent>>{},
        dispatcher: LoggingActionDispatcher(),
        child: Builder(
            builder: (context) => Scaffold(
                    body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          ),
                          title: Text(
                            'Run Comparison',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        SliverList.list(children: [
                          Center(
                              child: Text(
                            '${dateFormat.format(comparisonViewModel.base!.runDate)} <> ${dateFormat.format(comparisonViewModel.current!.runDate)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ))
                        ]),
                        SliverGroupedListView<ComparedResult, Type>(
                          elements: compareResult.compared,
                          groupBy: (ComparedResult element) =>
                              element.runtimeType,
                          itemComparator: (element1, element2) =>
                              element1.title.compareTo(element2.title),
                          itemBuilder: (context, element) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: compareResultProperties[
                                              element.runtimeType]
                                          ?.icon,
                                      title: Text(element.title),
                                      subtitle: Text(element.source),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(element.snippet)))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                          child: const Text('Visit'),
                                          onPressed: () => launchUrl(
                                              Uri.parse(element.link)),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          groupSeparatorBuilder: (value) =>
                              Text(value.toString()),
                          groupComparator: (value1, value2) =>
                              value1.toString().compareTo(value2.toString()),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
