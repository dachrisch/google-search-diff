import 'package:flutter/material.dart';
import 'package:google_search_diff/theme.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: MaterialTheme)
class LightTheme extends MaterialTheme {
  // Theme from: https://material-foundation.github.io/material-theme-builder/
  LightTheme() : super(ThemeData.light().primaryTextTheme);
}
