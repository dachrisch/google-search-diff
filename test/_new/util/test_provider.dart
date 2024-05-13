import 'package:flutter/material.dart';
import 'package:google_search_diff/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:relative_time/relative_time.dart';

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
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          RelativeTimeLocalizations.delegate,
        ],
        home: ChangeNotifierProvider<T>.value(
            value: providedValue, child: scaffoldUnderTest));
  }
}

class ScaffoldMultiProviderTestApp extends StatelessWidget {
  final Widget scaffoldUnderTest;
  final List<SingleChildWidget> providers;

  const ScaffoldMultiProviderTestApp({
    super.key,
    required this.providers,
    required this.scaffoldUnderTest,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          theme: LightTheme().light(),
          home: scaffoldUnderTest,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            RelativeTimeLocalizations.delegate,
          ],
        ));
  }
}
