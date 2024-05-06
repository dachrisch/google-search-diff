import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/run.dart';
import 'package:google_search_diff/_new/model/run_id.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:google_search_diff/_new/widget/header_listview.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScaffoldResultsModelProvider extends StatelessWidget {
  const ResultScaffoldResultsModelProvider({super.key});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    RunId resultsId = context.read<RunId>();
    QueriesStoreModel queriesStore = context.read<QueriesStoreModel>();
    RunModel resultsModel = queriesStore.findById(queryId).findById(resultsId);
    return ChangeNotifierProvider.value(
        value: resultsModel, child: const ResultScaffold());
  }
}

class ResultScaffold extends StatelessWidget {
  const ResultScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    RunModel results = context.read<RunModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Result - ${results.query.term}'),
      ),
      body: ListViewWithHeader(
        items: results.items,
        itemBuilder: (context, index) => ResultCard(results[index]),
        headerText: 'Results',
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final ResultModel result;

  ResultCard(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(result.title),
                subtitle: Text(result.source),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(result.snippet)))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Visit'),
                    onPressed: () => launchUrl(Uri.parse(result.link)),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ));
  }
}
