import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/results.dart';
import 'package:google_search_diff/_new/widget/result_card.dart';
import 'package:provider/provider.dart';

class QueryResultCardResultsModelProvider extends StatelessWidget {
  final ResultsModel resultsModel;

  const QueryResultCardResultsModelProvider(
      {super.key, required this.resultsModel});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
      value: resultsModel, child: const QueryResultCard());
}
