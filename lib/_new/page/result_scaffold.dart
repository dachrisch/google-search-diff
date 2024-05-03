import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/queries_store.dart';
import 'package:google_search_diff/_new/model/result.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/model/results_id.dart';
import 'package:google_search_diff/_new/routes/query_id.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScaffoldResultsModelProvider extends StatelessWidget {
  const ResultScaffoldResultsModelProvider({super.key});

  @override
  Widget build(BuildContext context) {
    QueryId queryId = context.read<QueryId>();
    ResultsId resultsId = context.read<ResultsId>();
    QueriesStoreModel queriesStore = context.read<QueriesStoreModel>();
    ResultsModel resultsModel =
        queriesStore.findById(queryId).findById(resultsId);
    return ChangeNotifierProvider.value(
        value: resultsModel, child: const ResultScaffold());
  }
}

class ResultScaffold extends StatelessWidget {
  const ResultScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    ResultsModel results = context.read<ResultsModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Result - ${results.query.query}'),
      ),
      body: ListView.builder(
        itemCount: results.items,
        itemBuilder: (context, index) => ResultCard(results[index]),
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
