import 'package:flutter/material.dart';
import 'package:google_search_diff/action/add_query_runs.dart';
import 'package:google_search_diff/action/dispatcher.dart';
import 'package:google_search_diff/action/intent/add_run_to_query_runs.dart';
import 'package:google_search_diff/action/intent/remove_query_runs.dart';
import 'package:google_search_diff/action/intent/search.dart';
import 'package:google_search_diff/action/remove_query_runs.dart';
import 'package:google_search_diff/action/search_and_add_run.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/queries_store.dart';
import 'package:google_search_diff/search/search_service.dart';
import 'package:google_search_diff/search/search_service_provider.dart';
import 'package:google_search_diff/theme.dart';
import 'package:google_search_diff/widget/queries/buttons/export.dart';
import 'package:google_search_diff/widget/queries/buttons/import.dart';
import 'package:google_search_diff/widget/queries/buttons/login.dart';
import 'package:google_search_diff/widget/queries/buttons/search.dart';
import 'package:google_search_diff/widget/runs/query_runs_card.dart';
import 'package:google_search_diff/widget/time_grouped_list_view.dart';
import 'package:google_search_diff/widget/timer_mixin.dart';
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
    SearchService searchService =
        context.read<SearchServiceProvider>().usedService;

    return Actions(
        actions: <Type, Action<Intent>>{
          AddRunToQueryRunsIntent: AddQueryRunsAction(queriesStore),
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
                      padding:
                          const EdgeInsets.only(top: 16, left: 8, right: 8),
                      child: CustomScrollView(
                        slivers: [
                          const _QueriesSliverAppBar(),
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
                                  childWidgetBuilder: () =>
                                      const QueryRunsCard(),
                                  dateForItem: (item) => item.query.createdDate,
                                  type: GroupListType.sliver,
                                )
                              : const _NoSearchesSliverFill(),
                        ],
                      ),
                    ),
                  ),
                )));
  }
}

class _NoSearchesSliverFill extends StatelessWidget {
  const _NoSearchesSliverFill();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Semantics(
              label: 'open search page',
              child: InkWell(
                key: const Key('no-queries-show-search-button'),
                onTap: () => showSearchPage(context),
                child: Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
              ),
            ),
            Text('No queries saved.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}

class _QueriesSliverAppBar extends StatelessWidget {
  const _QueriesSliverAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
      backgroundColor: MaterialTheme.lightScheme().primaryContainer,
      flexibleSpace: Semantics(
        label: 'Open search page',
        child: GestureDetector(
          onTap: () => showSearchPage(context),
        ),
      ),
      leading: Semantics(
        label: 'Open search page',
        child: InkWell(
          onTap: () => showSearchPage(context),
          child: Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
        ),
      ),
      automaticallyImplyLeading: false,
      title: Semantics(
        label: 'Open search page',
        child: InkWell(
          onTap: () => showSearchPage(context),
          child: Text(
            'SearchFlux',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      actions: [
        const SearchButton(),
        IconButton(
          key: const Key('open-menu-button'),
          icon: const Icon(Icons.more_vert_outlined),
          tooltip: 'Open Menu',
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (context) => const Wrap(
              children: [
                ExportListTile(),
                ImportListTile(),
                LoginListTile(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16)
      ],
    );
  }
}
