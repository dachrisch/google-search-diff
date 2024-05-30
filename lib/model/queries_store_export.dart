import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:google_search_diff/model/has_to_json.dart';
import 'package:google_search_diff/model/query.dart';
import 'package:google_search_diff/model/run.dart';
import 'package:json_annotation/json_annotation.dart';

part 'queries_store_export.g.dart';

@JsonSerializable()
class QueriesStoreExport implements HasToJson {
  final Iterable<Run> runs;

  QueriesStoreExport({required this.runs});

  Uint8List get bytes => Uint8List.fromList(utf8.encode(jsonEncode(toJson())));

  Digest get digest => sha256.convert(bytes);

  String get fileName => 'Queries-Export_$digest';

  Iterable<Query> get queries => runs.map((run) => run.query).toSet();

  @override
  Map<String, dynamic> toJson() => _$QueriesStoreExportToJson(this);

  factory QueriesStoreExport.fromJson(Map<String, dynamic> json) =>
      _$QueriesStoreExportFromJson(json);
}
