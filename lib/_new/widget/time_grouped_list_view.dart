import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/page/time_groups.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class TimeGroupedListView<T extends ChangeNotifier> extends StatelessWidget {
  final String headerText;

  final List<T> elements;
  final Widget Function() childWidgetBuilder;
  final DateTime Function(T item) dateForItem;

  const TimeGroupedListView({
    super.key,
    required this.elements,
    required this.headerText,
    required this.childWidgetBuilder,
    required this.dateForItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          headerText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          child: GroupedListView(
            elements: elements,
            itemBuilder: (context, T item) => ChangeNotifierProvider.value(
                value: item, child: childWidgetBuilder()),
            groupSeparatorBuilder: (TimeUnit value) => Center(
                child: Text(TimeGroups.map[value]!,
                    style: Theme.of(context).textTheme.titleSmall)),
            groupBy: (T item) {
              try {
                return TimeUnit.values.firstWhere((tu) =>
                    tu.difference(
                        dateForItem(item).difference(DateTime.now()).abs()) >
                    1);
              } on StateError {
                return TimeUnit.second;
              }
            },
            itemComparator: (element1, element2) =>
                dateForItem(element2).compareTo(dateForItem(element1)),
          ),
        ),
      ],
    );
  }
}
