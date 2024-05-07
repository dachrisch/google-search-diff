import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/run.dart';

class AddResultsIntent extends Intent {
  final Run results;

  const AddResultsIntent(this.results);
}
