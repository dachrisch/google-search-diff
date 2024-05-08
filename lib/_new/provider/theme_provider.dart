import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/theme.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: MaterialTheme)
class LightTheme extends MaterialTheme {
  LightTheme() : super(ThemeData.light().primaryTextTheme);
}
