import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScaffoldValueProviderTestApp<T extends ChangeNotifier>
    extends StatelessWidget {
  final Widget scaffoldUnderTest;
  final T providedValue;

  const ScaffoldValueProviderTestApp({
    super.key,
    required this.providedValue,
    required this.scaffoldUnderTest,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChangeNotifierProvider<T>.value(
            value: providedValue, child: scaffoldUnderTest));
  }
}
