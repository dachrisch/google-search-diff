import 'package:flutter/material.dart';
import 'package:google_search_diff/model/run.dart';

class AddRunToQueryRunsIntent extends Intent {
  final Run run;

  const AddRunToQueryRunsIntent(this.run);
}
