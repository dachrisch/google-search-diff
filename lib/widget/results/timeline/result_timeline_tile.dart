import 'package:flutter/material.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/routes/route_navigate_extension.dart';
import 'package:google_search_diff/service/result_service.dart';
import 'package:google_search_diff/widget/comparison/comparison_view_model.dart';
import 'package:relative_time/relative_time.dart';
import 'package:timeline_tile/timeline_tile.dart';

enum TilePosition {
  first,
  last,
  between;

  factory TilePosition.fromIndex(int index, Iterable<dynamic> list) {
    if (index == 0) {
      return TilePosition.first;
    } else if (index == list.length - 1) {
      return TilePosition.last;
    } else {
      return TilePosition.between;
    }
  }
}

class ResultTimelineTile extends StatelessWidget {
  final ResultHistory resultHistory;
  final ComparedResultViewProperties viewProperties;
  final Run run;

  final TilePosition position;

  ResultTimelineTile({
    super.key,
    required this.resultHistory,
    required this.position,
  })  : viewProperties =
            ComparedResultViewProperties.of(resultHistory.comparedResult),
        run = resultHistory.run;

  @override
  Widget build(BuildContext context) {
    RelativeTime format = RelativeTime(context);
    return TimelineTile(
      alignment: TimelineAlign.center,
      isFirst: position == TilePosition.first,
      isLast: position == TilePosition.last,
      indicatorStyle: IndicatorStyle(
          height: 40,
          width: 40,
          color: Colors.white,
          iconStyle: IconStyle(
              iconData: viewProperties.iconData, color: viewProperties.color)),
      startChild: ListTile(
        title: Row(
          children: [
            Text(viewProperties.name),
            const Spacer(),
            Text(
              format.format(run.runDate),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
      endChild: ListTile(
        title: Row(
          children: [
            Text('Results: ${run.results.length}'),
            const Spacer(),
            TextButton(
                onPressed: () => context.gotToRun(run),
                child: const Text(
                  'View run',
                  textAlign: TextAlign.right,
                ))
          ],
        ),
      ),
    );
  }
}
