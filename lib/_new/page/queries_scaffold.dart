import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/query.dart';
import 'package:google_search_diff/_new/page/search_provider_delegate.dart';
import 'package:google_search_diff/_new/provider/query_card_model.dart';
import 'package:google_search_diff/_new/service/search_service.dart';
import 'package:provider/provider.dart';

class QueriesScaffold extends StatelessWidget {
  const QueriesScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    QueriesStoreModel queriesStore = context.watch<QueriesStoreModel>();

    return Scaffold(
      appBar: AppBar(
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
                      onSave: (query) {
                        queriesStore.add(query);
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
      body: ListView.builder(
        itemCount: queriesStore.items,
        itemBuilder: (context, index) =>
            QueryCardQueryModelProvider(searchQuery: queriesStore.at(index)),
      ),
      floatingActionButton: FloatingActionButton.small(
          key: const Key('add-search-query-button'),
          onPressed: () {
            queriesStore.add(Query('new ${queriesStore.items}'));
          },
          child: const Icon(Icons.add_box_rounded)),
    );
  }
}
