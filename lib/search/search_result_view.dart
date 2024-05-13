import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/result/result_card.dart';

class SearchResultsView extends StatefulWidget {
  final Future<void> Function(Run results) onSave;
  final Run run;

  const SearchResultsView({
    super.key,
    required this.onSave,
    required this.run,
  });

  @override
  State<StatefulWidget> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemBuilder: (context, index) =>
                ResultCard(result: widget.run.results[index]),
            itemCount: widget.run.items),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AsyncButtonBuilder(
            child: const Icon(Icons.add_outlined),
            onPressed: () async => await widget.onSave(widget.run),
            builder: (context, child, callback, buttonState) {
              return FloatingActionButton.extended(
                  key: const Key('add-search-query-button'),
                  onPressed: callback,
                  icon: child,
                  label: const Text('Save Query'));
            }));
  }
}
