import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/model/search_results.dart';

class SearchResultListTile extends StatelessWidget {
  final SearchResult searchResult;
  final FimberLog logger = FimberLog('tile');

  final void Function(dynamic e) doDelete;

  SearchResultListTile(
      {super.key, required this.searchResult, required this.doDelete});


  @override
  Widget build(BuildContext context) {
    logger.d('Drawing tile $key');
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(searchResult.status.icon, color: searchResult.status.color[400]),
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
                    onPressed: () {
                      /* ... */
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ));
  }
}
