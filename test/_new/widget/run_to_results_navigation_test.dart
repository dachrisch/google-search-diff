import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/page/result_scaffold.dart';
import 'package:google_search_diff/_new/routes/routes.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:google_search_diff/_new/widget/query_card.dart';
import 'package:google_search_diff/_new/widget/run_card.dart';
import 'package:provider/provider.dart';


class TestImageProvider extends ImageProvider {
  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    // TODO: implement obtainKey
    throw UnimplementedError();
  }

}




void main() {
  testWidgets('Transitions from Query to Result View',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    Provider.debugCheckInvalidValueType = null;
    var queriesStore = QueriesStoreModel();
    await queriesStore.add(QueryRunsModel.fromRunModel(
        Results(Query('Saved query 1'), [ResultModel(title: 'result 1')])));
    var theme = MaterialTheme(ThemeData.light().primaryTextTheme).light();

    final PlatformAssetBundle testBundle = PlatformAssetBundle();
    testBundle.load('assets/logo.png');

    await tester.pumpWidget(DefaultAssetBundle(bundle: testBundle, child: RouterApp(
      theme: theme,
      queriesStore: queriesStore,
    )));

    expect(queriesStore.items, 1);
    expect(find.byType(SingleQueryCard), findsOne);

    await tester.tap(find.byType(SingleQueryCard));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(RunCard));
    await tester.pumpAndSettle();
    expect(find.byType(ResultCard), findsOneWidget);
  });
}
