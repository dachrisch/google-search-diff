import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/routes/routes.dart';
import 'package:google_search_diff/_new/service/search_service.dart';

class SearchProviderSearchDelegate extends SearchDelegate<Query> {
  final SearchService searchProvider;

  SearchProviderSearchDelegate({required this.searchProvider});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: query.isNotEmpty ? () {} : null,
          icon: const Icon(Icons.favorite_outline)),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ResultModel>>(
      future: searchProvider.doSearch(Query(query)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].title),
                    ),
                  ),
              itemCount: snapshot.data!.length);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) => null, itemCount: 0);
  }
}
