import 'package:flutter/material.dart';
import 'package:google_search_diff/dependencies.dart';
import 'package:google_search_diff/model/result.dart';
import 'package:google_search_diff/model/result_id.dart';
import 'package:google_search_diff/service/result_service.dart';
import 'package:google_search_diff/widget/results/result_card.dart';
import 'package:google_search_diff/widget/results/timeline/result_timeline_tile.dart';
import 'package:provider/provider.dart';

class ResultTimelinePage extends StatelessWidget {
  final ResultService resultService = getIt<ResultService>();

  ResultTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    var resultId = context.read<ResultId>();
    return Provider(
      create: (context) => resultService.byId(resultId),
      child: ResultTimelinePageScaffold(),
    );
  }
}

class ResultTimelinePageScaffold extends StatelessWidget {
  final ResultService resultService = getIt<ResultService>();

  ResultTimelinePageScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    Result result = context.read<Result>();
    List<ResultHistory> resultHistory = resultService.historyOf(result);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Result - History'),
      ),
      body: Column(
        children: [
          Center(
              child: ResultCard(
            result: result,
          )),
          Expanded(
            child: ListView.builder(
              itemCount: resultHistory.length,
              itemBuilder: (context, index) {
                return ResultTimelineTile(
                  resultHistory: resultHistory[index],
                  position: TilePosition.fromIndex(index, resultHistory),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
