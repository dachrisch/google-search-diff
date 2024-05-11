import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/action/dispatcher.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Actions(
        actions: <Type, Action<Intent>>{},
        dispatcher: LoggingActionDispatcher(),
        child: Builder(
            builder: (context) => const Scaffold(
                    body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                    child: Center(child: Text('Comparison')),
                  ),
                ))));
  }
}
