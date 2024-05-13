import 'package:flutter/material.dart';
import 'package:google_search_diff/model/run.dart';

class RemoveRunIntent extends Intent {
  final Run run;

  const RemoveRunIntent({required this.run});
}
