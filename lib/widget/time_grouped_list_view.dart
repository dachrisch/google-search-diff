import 'package:flutter/material.dart';
import 'package:google_search_diff/widget/comparison/time_groups.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

enum GroupListType { sliver, widget }

class TimeGroupedListView<T extends ChangeNotifier> extends StatelessWidget {
  final List<T> elements;
  final Widget Function() childWidgetBuilder;
  final DateTime Function(T item) dateForItem;

  final GroupListType type;

  const TimeGroupedListView({
    super.key,
    required this.type,
    required this.elements,
    required this.childWidgetBuilder,
    required this.dateForItem,
  });

  @override
  Widget build(BuildContext context) {
    // Common logic for grouping and comparison
    groupComparator(TimeUnit value1, TimeUnit value2) =>
        value1.microseconds.compareTo(value2.microseconds);
    itemComparator(element1, element2) =>
        dateForItem(element2).compareTo(dateForItem(element1));
    groupBy(T element) {
      try {
        return TimeUnit.values.firstWhere((tu) =>
            tu.difference(
                dateForItem(element).difference(DateTime.now()).abs()) >
            1);
      } on StateError {
        return TimeUnit.second;
      }
    }

    Widget groupSeparatorBuilder(TimeUnit value) {
      if (TimeGroups.map[value] == null) {
        print(value);
      }
      return Center(
          child: Text(TimeGroups.map[value]!,
              style: Theme.of(context).textTheme.titleSmall));
    }

    itemBuilder(BuildContext context, T element) =>
        ChangeNotifierProvider.value(
            value: element, child: childWidgetBuilder());

    // Return either a sliver or a normal grouped list based on `isSliver`
    switch (type) {
      case GroupListType.sliver:
        return SliverGroupedListView<T, TimeUnit>(
          groupComparator: groupComparator,
          itemComparator: itemComparator,
          sort: true,
          elements: elements,
          groupBy: groupBy,
          itemBuilder: itemBuilder,
          groupSeparatorBuilder: groupSeparatorBuilder,
        );
      case GroupListType.widget:
        return GroupedListView<T, TimeUnit>(
          groupComparator: groupComparator,
          itemComparator: itemComparator,
          sort: true,
          elements: elements,
          groupBy: groupBy,
          itemBuilder: itemBuilder,
          groupSeparatorBuilder: groupSeparatorBuilder,
        );
    }
  }
}
