import 'package:flutter/material.dart';

class ListViewWithHeader extends StatelessWidget {
  final String headerText;
  final NullableIndexedWidgetBuilder itemBuilder;

  final int items;

  const ListViewWithHeader(
      {super.key,
      required this.headerText,
      required this.itemBuilder,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        Row(children: [
          Expanded(
              child: Text(headerText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  )))
        ]),
        Expanded(
            child: ListView.builder(
          itemCount: items,
          itemBuilder: itemBuilder,
        ))
      ]),
    );
  }
}
