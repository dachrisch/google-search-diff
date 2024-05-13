import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_search_diff/logger.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:google_search_diff/widget/result/result_card.dart';
import 'package:logger/logger.dart';

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
  final ScrollController controller = ScrollController();
  final Logger l = getLogger('result-view');
  bool atTop = true;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        atTop = controller.offset == 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            controller: controller,
            itemBuilder: (context, index) =>
                ResultCard(result: widget.run.results[index]),
            itemCount: widget.run.items),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: AsyncButtonBuilder(
            child: const Icon(Icons.add_outlined),
            onPressed: () async => await widget.onSave(widget.run),
            builder: (context, child, callback, buttonState) {
              return AnimatedSwitcher(
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.fastOutSlowIn,
                duration: Durations.extralong4,
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(10, 0), end: const Offset(0, 0))
                      .animate(animation),
                  child: child,
                ),
                child: atTop
                    ? FloatingActionButton.extended(
                        key: const Key('add-search-query-button'),
                        onPressed: callback,
                        icon: child,
                        label: const Text('Save Query'))
                    : FloatingActionButton.small(
                        key: const Key('add-search-query-button'),
                        onPressed: callback,
                        child: child),
              );
            }));
  }
}
