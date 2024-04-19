import 'package:flutter/material.dart';
import 'package:google_search_diff/model/search_results.dart';

class SearchResultListTile extends StatelessWidget {
  final SearchResult searchResult;
  const SearchResultListTile({super.key, required this.searchResult});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.circle;
    switch (searchResult.status) {
      case SearchResultsStatus.added:
        icon = Icons.arrow_right_outlined;
        break;
      case SearchResultsStatus.existing:
        icon = Icons.circle;
        break;
      case SearchResultsStatus.removed:
        icon = Icons.arrow_left_outlined;
        break;
      default:
    }
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(icon),
                title: Text(searchResult.title),
                subtitle: Text(searchResult.source),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(searchResult.snippet)))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Remove'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('Visit'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ));
  }
}
