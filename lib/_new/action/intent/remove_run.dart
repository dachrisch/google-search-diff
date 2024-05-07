import 'package:flutter/material.dart';
import 'package:google_search_diff/_new/model/run.dart';

class RemoveRunIntent extends Intent {
  final Run run;

  const RemoveRunIntent({required this.run});
}
