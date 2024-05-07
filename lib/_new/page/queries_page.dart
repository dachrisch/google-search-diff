import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/action/add_result.dart';
import 'package:google_search_diff/_new/action/dispatcher.dart';
import 'package:google_search_diff/_new/action/intent/add_result.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/page/search_provider_delegate.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:google_search_diff/_new/widget/card/query_card.dart';
import 'package:google_search_diff/_new/widget/time_grouped_list_view.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class QueriesPage extends StatefulWidget {
  const QueriesPage({super.key});

  @override
  State<StatefulWidget> createState() => _QueriesPageState();
}

class _QueriesPageState extends State<QueriesPage> with TimerMixin {
  final Logger l = getLogger('QueriesScaffold');

  @override
  Widget build(BuildContext context) {
    QueriesStore queriesStore = context.watch<QueriesStore>();

    return Actions(
        actions: <Type, Action<Intent>>{
          AddResultsIntent: AddResultsAction(queriesStore)
        },
        dispatcher: LoggingActionDispatcher(),
        child: Builder(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  backgroundColor: MaterialTheme.lightScheme().primaryContainer,
                  leading:
                      Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
                  automaticallyImplyLeading: false,
                  title: Text(
                    'SearchFlux',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  actions: const [_SearchButton(), SizedBox(width: 16)],
                ),
                body: TimeGroupedListView(
                  headerText: 'Your saved queries',
                  elements: queriesStore.queryRuns,
                  childWidgetBuilder: () => const QueryCard(),
                  dateForItem: (QueryRuns item) => item.query.createdDate,
                ))));
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        key: const Key('show-searchbar-button'),
        onPressed: () {
          showSearch(
              context: context,
              delegate: SearchProviderSearchDelegate(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  searchProvider: context.read<SearchService>(),
                  onSave: (results) => (Actions.invoke<AddResultsIntent>(
                              context, AddResultsIntent(results)) as Future)
                          .then((_) {
                        if (GoRouter.maybeOf(context) != null) {
                          // avoid context pop when used standalone (in tests)
                          context.pop();
                        }
                      })));
        },
        icon: const Icon(Icons.search));
  }
}
