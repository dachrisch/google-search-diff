import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_search_diff/action/intent/add_run_to_query_runs.dart';
import 'package:google_search_diff/search/search_provider_delegate.dart';
import 'package:google_search_diff/search/search_service_provider.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
      key: const Key('show-searchbar-button'),
      tooltip: 'Open search page',
      onPressed: () => showSearchPage(context),
      icon: const Icon(Icons.search));
}

void showSearchPage(BuildContext context) {
  showSearch(
      context: context,
      delegate: SearchProviderSearchDelegate(
          textStyle: Theme.of(context).textTheme.titleMedium,
          searchProvider: context.read<SearchServiceProvider>().usedService,
          onSave: (results) => (Actions.invoke<AddRunToQueryRunsIntent>(
                      context, AddRunToQueryRunsIntent(results)) as Future)
                  .then((_) {
                if (GoRouter.maybeOf(context) != null) {
                  // avoid context pop when used standalone (in tests)
                  context.pop();
                }
              })));
}
