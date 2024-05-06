import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query_runs.dart';
import 'package:google_search_diff/_new/page/search_provider_delegate.dart';
import 'package:google_search_diff/_new/provider/query_card_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:google_search_diff/_new/widget/header_listview.dart';
import 'package:provider/provider.dart';

class QueriesScaffold extends StatelessWidget {
  const QueriesScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    QueriesStoreModel queriesStore = context.watch<QueriesStoreModel>();

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.1,
              automaticallyImplyLeading: false,
          title: const Text('SearchFlux'),
          actions: [
            IconButton(
                key: const Key('show-searchbar-button'),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchProviderSearchDelegate(
                        searchProvider: context.read<SearchService>(),
                        onSave: (results) {
                          queriesStore
                              .add(QueryRunsModel.fromRunModel(results));
                          if (GoRouter.maybeOf(context) != null) {
                            // avoid context pop when used standalone (in tests)
                            context.pop();
                          }
                        },
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
            itemBuilder: (context, index) =>
                QueryCardQueryModelProvider(queryRuns: queriesStore.at(index)),
                items: queriesStore.items)));
  }
}
