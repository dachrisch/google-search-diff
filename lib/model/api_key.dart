import 'package:google_search_diff/model/has_to_json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_key.g.dart';

@JsonSerializable()
class ApiKey implements HasToJson {
  final String key;

  ApiKey({required this.key});

  @override
  Map<String, dynamic> toJson() => _$ApiKeyToJson(this);

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);
}
