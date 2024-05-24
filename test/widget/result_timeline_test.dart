import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/comparison.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/query_runs.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/result_id.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/service/result_service.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:google_search_diff/widget/results/result_card.dart';
import 'package:google_search_diff/widget/results/timeline/result_timeline_page.dart';
import 'package:google_search_diff/widget/results/timeline/result_timeline_tile.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../service/widget_tester_extension.dart';
import '../util/test_provider.dart';

void main() {
  testWidgets('View result timeline', (tester) async {
    var mocked = Mocked();
    var queriesStore = mocked.queriesStore;

    var query = Query('Test query');
    var result = Result(title: 'Test', source: 'T', link: 'http://example.com');
    var run = Run(query, [result]);
    var queryRunsModel = QueryRuns.fromRun(run, mocked.dbRunsService);
    await queriesStore
        .addQueryRuns(queryRunsModel)
        .then((queryRuns) => queryRuns
            .addRun(Run(query, [result],
                runDate: DateTime.now().subtract(const Duration(hours: 1))))
            .then((_) => queryRuns))
        .then((queryRuns) => queryRuns
            .addRun(Run(query, [],
                runDate: DateTime.now().subtract(const Duration(hours: 2))))
            .then((_) => queryRuns))
        .then((queryRuns) => queryRuns
            .addRun(Run(query, [result],
                runDate: DateTime.now().subtract(const Duration(hours: 3))))
            .then((_) => queryRuns));

    getIt.registerSingleton(ResultService(
        dbRunsService: mocked.dbRunsService, queriesStore: queriesStore));
    await tester.pumpWidget(ScaffoldMultiProviderTestApp(
      providers: [
        ChangeNotifierProvider.value(value: queriesStore),
        Provider<ResultId>.value(
          value: result.id,
        ),
      ],
      scaffoldUnderTest: ResultTimelinePage(),
    ));

    expect(find.byType(ResultCard), findsNWidgets(1));
    expect(find.byType(ResultTimelineTile), findsNWidgets(4));
    // first existing
    expect(
        find.descendant(
            of: find.byType(ResultTimelineTile),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is TimelineTile &&
                  widget.isFirst &&
                  widget.indicatorStyle.iconStyle?.iconData ==
                      compareResultProperties[ExistingResult]?.iconData,
            )),
        findsOneWidget);
    // last added
    expect(
        find.descendant(
            of: find.byType(ResultTimelineTile),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is TimelineTile &&
                  widget.isLast &&
                  widget.indicatorStyle.iconStyle?.iconData ==
                      compareResultProperties[AddedResult]?.iconData,
            )),
        findsOneWidget);
    // between removed
    expect(
        find.descendant(
            of: find.byType(ResultTimelineTile),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is TimelineTile &&
                  !widget.isLast &&
                  !widget.isFirst &&
                  widget.indicatorStyle.iconStyle?.iconData ==
                      compareResultProperties[RemovedResult]?.iconData,
            )),
        findsOneWidget);
    // between added
    expect(
        find.descendant(
            of: find.byType(ResultTimelineTile),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is TimelineTile &&
                  !widget.isLast &&
                  !widget.isFirst &&
                  widget.indicatorStyle.iconStyle?.iconData ==
                      compareResultProperties[AddedResult]?.iconData,
            )),
        findsOneWidget);
  });
}
