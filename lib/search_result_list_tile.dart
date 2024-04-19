import 'package:flutter/material.dart';
import 'package:google_search_diff/model/search_results.dart';

class SearchResultListTile extends StatelessWidget {
  final SearchResult searchResult;

  final void Function(dynamic e) doDelete;
  const SearchResultListTile(
      {super.key, required this.searchResult, required this.doDelete});

  @override
  Widget build(BuildContext context) {
    Icon icon = const Icon(Icons.circle);
    switch (searchResult.status) {
      case SearchResultsStatus.added:
        icon = Icon(
          Icons.keyboard_double_arrow_right_outlined,
          color: Colors.green[400],
        );
        break;
      case SearchResultsStatus.existing:
        icon = Icon(
          Icons.compare_arrows_outlined,
          color: Colors.grey[600],
        );
        break;
      case SearchResultsStatus.removed:
        icon = Icon(
          Icons.keyboard_double_arrow_left_outlined,
          color: Colors.red[400],
        );
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
                leading: icon,
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
                    onPressed: () => doDelete(searchResult),
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
