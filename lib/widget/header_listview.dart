import 'package:flutter/material.dart';

class ListViewWithHeader<T extends Object> extends StatelessWidget {
  final String headerText;
  final IndexedWidgetBuilder itemBuilder;
  final Widget filterWidget;

  final int items;

  const ListViewWithHeader(
      {super.key,
      required this.headerText,
      required this.itemBuilder,
      required this.items,
      required this.filterWidget});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        const SizedBox(width: 20),
        Expanded(child: Text(headerText)),
        const SizedBox(),
        filterWidget,
        const SizedBox(
          width: 20,
        )
      ]),
      Expanded(
          child: ListView.builder(
        itemCount: items,
        itemBuilder: itemBuilder,
      ))
    ]);
  }
}
