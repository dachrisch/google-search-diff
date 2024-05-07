import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/results.dart';

class AddResultsIntent extends Intent {
  final Results results;

  const AddResultsIntent(this.results);
}
