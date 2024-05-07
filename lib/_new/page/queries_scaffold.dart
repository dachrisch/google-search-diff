import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/page/search_provider_delegate.dart';
import 'package:google_search_diff/_new/provider/query_card_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:google_search_diff/_new/widget/header_listview.dart';
import 'package:google_search_diff/_new/widget/timer_mixin.dart';
import 'package:provider/provider.dart';

class QueriesScaffold extends StatefulWidget {
  const QueriesScaffold({super.key});

  @override
  State<StatefulWidget> createState() => _QueriesScaffoldState();
}

class _QueriesScaffoldState extends State<QueriesScaffold> with TimerMixin {
  @override
  Widget build(BuildContext context) {
    QueriesStoreModel queriesStore = context.watch<QueriesStoreModel>();

    return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          backgroundColor: MaterialTheme.lightScheme().primaryContainer,
          leading: Image.asset('assets/logo.png', fit: BoxFit.scaleDown),
          automaticallyImplyLeading: false,
          title: Text(
            'SearchFlux',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            IconButton(
                key: const Key('show-searchbar-button'),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchProviderSearchDelegate(
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        searchProvider: context.read<SearchService>(),
                        onSave: (results) => queriesStore
                            .add(QueryRunsModel.fromRunModel(results))
                            .then((value) {
                          if (GoRouter.maybeOf(context) != null) {
                            // avoid context pop when used standalone (in tests)
                            context.pop();
                          }
                        }),
                      ));
                },
                icon: const Icon(Icons.search)),
            const SizedBox(width: 16)
          ],
        ),
        body: ListViewWithHeader(
            headerText: queriesStore.items > 0
                ? 'Your saved queries'
                : 'No saved queries',
            itemBuilder: (context, index) => QueryCardQueryModelProvider(
                queryRuns: queriesStore.at(index)),
            items: queriesStore.items));
  }
}
