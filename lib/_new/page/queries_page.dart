import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/action/add_result.dart';
import 'package:google_search_diff/_new/action/dispatcher.dart';
import 'package:google_search_diff/_new/action/intent/add_result.dart';
import 'package:google_search_diff/_new/action/intent/remove_query_runs.dart';
import 'package:google_search_diff/_new/action/intent/search.dart';
import 'package:google_search_diff/_new/action/remove_query_runs.dart';
import 'package:google_search_diff/_new/action/search_and_add_run.dart';
import 'package:google_search_diff/_new/logger.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/page/search_provider_delegate.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:google_search_diff/_new/widget/card/query_runs_card.dart';
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
    SearchService searchService = context.read<SearchService>();

    return Actions(
        actions: <Type, Action<Intent>>{
          AddResultsIntent: AddResultsAction(queriesStore),
          RemoveQueryRunsIntent:
              RemoveQueryRunsAction(context, queriesStore: queriesStore),
          SearchIntent:
              SearchAndAddRunAction(context, searchService: searchService)
        },
        dispatcher: LoggingActionDispatcher(),
        child: Builder(
            builder: (context) => Scaffold(
                    body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          backgroundColor:
                              MaterialTheme.lightScheme().primaryContainer,
                          leading: InkWell(
                            onTap: () => showSearchPage(context),
                            child: Image.asset('assets/logo.png',
                                fit: BoxFit.scaleDown),
                          ),
                          automaticallyImplyLeading: false,
                          title: InkWell(
                            onTap: () => showSearchPage(context),
                            child: Text(
                              'SearchFlux',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          actions: const [_SearchButton(), SizedBox(width: 16)],
                        ),
                        SliverList.list(children: [
                          Center(
                              child: Text(
                            'Your saved queries',
                            style: Theme.of(context).textTheme.titleMedium,
                          ))
                        ]),
                        queriesStore.items > 0
                            ? TimeGroupedListView(
                                elements: queriesStore.queryRuns,
                                childWidgetBuilder: () => const QueryRunsCard(),
                                dateForItem: (item) => item.query.createdDate,
                                type: GroupListType.sliver,
                              )
                            : SliverFillRemaining(
                                child: Center(
                                  child: Center(
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () => showSearchPage(context),
                                          child: Image.asset('assets/logo.png',
                                              fit: BoxFit.scaleDown),
                                        ),
                                        Text('No queries saved.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(color: Colors.grey))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ))));
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        key: const Key('show-searchbar-button'),
        onPressed: () => showSearchPage(context),
        icon: const Icon(Icons.search));
  }
}

void showSearchPage(BuildContext context) {
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
}
